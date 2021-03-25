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
%include "std_string.i"
%include "stdint.i"

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

%template(BaseDeviceVector) std::vector<INDI::BaseDevice *>;
%template(PropertyVector) std::vector<INDI::Property *>;

%ignore INDI::PropertyView::apply;
%ignore INDI::PropertyView::define;
%ignore INDI::PropertyView::vapply;
%ignore INDI::PropertyView::vdefine;
%ignore INDI::Property::apply;
%ignore INDI::Property::define;


%include <indimacros.h>
%include <indibasetypes.h>
%include <indibase.h>
%include <indiapi.h>
%include <baseclient.h>
%include <basedevice.h>
%include <indiwidgettraits.h>
%include <indipropertyview.h>
%template(ITextPropertyview) INDI::PropertyView<IText>;
%template(INumberPropertyview) INDI::PropertyView<INumber>;
%template(ISwitchPropertyview) INDI::PropertyView<ISwitch>;
%template(ILightPropertyview) INDI::PropertyView<ILight>;
%template(IBLOBPropertyview) INDI::PropertyView<IBLOB>;
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
 };

%extend INDI::BaseClient {
  %typemap(in) (char *data, long len) {
    $1 = PyBytes_AsString($input);
    $2 = PyBytes_Size($input);
  }


  public:
    void sendOneBlobFromBuffer(const char *name, const char *type, char *data, long len) {
      $self->sendOneBlob(name, len, type, (void*)(data));
    }
  }
