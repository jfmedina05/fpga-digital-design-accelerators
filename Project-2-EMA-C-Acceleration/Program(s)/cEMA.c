//https://docs.python.org/3/extending/extending.html

#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include "ema.h"

//resets the ema initial value
static PyObject * 
reset(PyObject *self)
{
    //ema!
    ema_reset();

    Py_RETURN_NONE;
}

// runs EMA on a single value from python
static PyObject *
ema(PyObject *self, PyObject *args)
{
    unsigned long num;

    if (!PyArg_ParseTuple(args, "l", &num))
        return NULL;
    
    //FIXME
    long res = ema_simple((long)num); 
    
    return PyLong_FromLong(res);
}

// runs EMA on a list of integers in a python object
//
//helpful links:
//https://stackoverflow.com/questions/39063112/passing-a-python-list-to-c-function-using-the-python-c-api
// https://stackoverflow.com/questions/22458298/extending-python-with-c-pass-a-list-to-pyarg-parsetuple
static PyObject *
ema_all(PyObject *self, PyObject *args)
{
    PyObject *x_lst; //input list
    PyObject *y_lst; //output list
    long sz;

    //parse the list argument
    if (!PyArg_ParseTuple(args, "O", &x_lst)) {
        return NULL;
    }
    
    sz = PyObject_Length(x_lst);

    //stop early if this isn't a list
    if (sz < 0){
        return NULL;
    }
   
    //create the output list
    y_lst = PyList_New(sz);

    //reset ema
    ema_reset();
    
    //FIXME
    // iterate and compute EMA
    PyObject *seq = PySequence_Fast(x_lst, "Expected a sequence");
    if (!seq) {
        Py_DECREF(y_lst);
        return NULL;
    }

    PyObject **items = PySequence_Fast_ITEMS(seq);

    for (Py_ssize_t i = 0; i < sz; ++i)
    {
        long x = PyLong_AsLong(items[i]);
        if (PyErr_Occurred())
        {
            Py_DECREF(seq);
            Py_DECREF(y_lst);
            return NULL;
        }

        long y = ema_simple(x); // update EMA

        PyObject *py_y = PyLong_FromLong(y);
        if (!py_y || PyList_SetItem(y_lst, i, py_y) != 0)
        {
            Py_XDECREF(py_y);
            Py_DECREF(seq);
            Py_DECREF(y_lst);
            return NULL;
        }
    }

    Py_DECREF(seq);
    return y_lst;
}
  

static PyMethodDef cEMAMethods[] = {
    {"reset", (PyCFunction) reset, METH_VARARGS, "reset the ema initial state"},
    {"ema", ema, METH_VARARGS, "run ema on a unint64_t value"}, 
    {"ema_all",  ema_all, METH_VARARGS, "run ema on a list of values"}, 
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

static struct PyModuleDef cEMAModule = {
    PyModuleDef_HEAD_INIT,
    "cEMA",   /* name of module */
    NULL, /* module documentation, may be NULL */
    -1,       /* size of per-interpreter state of the module,
                 or -1 if the module keeps state in global variables. */
    cEMAMethods
};

PyMODINIT_FUNC
PyInit_cEMA(void)
{
    return PyModule_Create(&cEMAModule);
}

