%module(directors="1") PyIndi
%{
#include <indibase.h>
#include <indiapi.h>
#include <baseclient.h>
#include <basedevice.h>
#include <indiproperty.h>

#include <stdexcept>
%}

%include "std_vector.i"
%include "std_except.i"

%feature("director") BaseClient;
%feature("director:except") {
    if( $error != NULL ) {
        PyObject *ptype, *pvalue, *ptraceback;
        PyErr_Fetch( &ptype, &pvalue, &ptraceback );
        PyErr_Restore( ptype, pvalue, ptraceback );
        PyErr_Print();
        Py_Exit(1);
    }
} 
//Warning 451
%typemap(varin) const char * {
   SWIG_Error(SWIG_AttributeError,"Variable $symname is read-only.");
   SWIG_fail;
}

// Memory leak const std::string *
%typemap(out) std::string {
  $result = PyString_FromString($1.c_str());
 } 

%typemap(in) const std::string & (std::string temp) {
  char * buf;
  Py_ssize_t len;
  if (PyString_AsStringAndSize($input, &buf, &len) == -1)
    return NULL;
  temp = std::string(buf, len);
  $1 = &temp;
 }


%template(BaseDeviceVector) std::vector<INDI::BaseDevice *>;
%template(PropertyVector) std::vector<INDI::Property *>;

%include <indibasetypes.h>
%include <indibase.h>
%include <indiapi.h>
%include <baseclient.h>
%include <basedevice.h>
%include <indiproperty.h>

typedef enum {
B_NEVER=0,
B_ALSO,
B_ONLY
} BLOBHandling;

%extend _ITextVectorProperty {
  IText *__getitem__(int index) throw(std::out_of_range) {
    if (index >= $self->ntp) throw std::out_of_range("VectorProperty index out of bounds");
    return $self->tp + index;
  }
  int __len__() {
    return $self->ntp;
  }
 };
%extend _INumberVectorProperty {
  INumber *__getitem__(int index) throw(std::out_of_range) {
    if (index >= $self->nnp) throw std::out_of_range("VectorProperty index out of bounds");
    return $self->np + index;
  }
  int __len__() {
    return $self->nnp;
  }
 };
%extend _ISwitchVectorProperty {
  ISwitch *__getitem__(int index) throw(std::out_of_range) {
    if (index >= $self->nsp) throw std::out_of_range("VectorProperty index out of bounds");
    return $self->sp + index;
  }
  int __len__() {
    return $self->nsp;
  }
 };
%extend _ILightVectorProperty {
  ILight *__getitem__(int index) throw(std::out_of_range) {
    if (index >= $self->nlp) throw std::out_of_range("VectorProperty index out of bounds");
    return $self->lp + index;
  }
  int __len__() {
    return $self->nlp;
  }
 };
%extend _IBLOBVectorProperty {
  IBLOB *__getitem__(int index) throw(std::out_of_range) {
    if (index >= $self->nbp) throw std::out_of_range("VectorProperty index out of bounds");
    return $self->bp + index;
  }
  int __len__() {
    return $self->nbp;
  }
 };


%extend IBLOB {
  PyObject *getblobdata() {
    PyObject *result;

    result = PyByteArray_FromStringAndSize((const char*) $self->blob, $self->size);
    return result;
  }
 }
