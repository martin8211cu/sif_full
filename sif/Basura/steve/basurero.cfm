<!--- CLIENTES --->
<cfinvoke component="cmMisFunciones" method="tmp_BorrarTabla" returnvariable="rError" />
<cfinvoke component="cmMisFunciones" method="tmp_CrearTabla" returnvariable="rError" />
<cfinvoke component="cmMisFunciones" method="tmp_LlenarTablaReales" returnvariable="rError" />

<cflocation url="basura.cfm">