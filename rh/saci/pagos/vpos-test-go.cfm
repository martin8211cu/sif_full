<!---
<cfparam name="form.monto" default="100" type="numeric">
<cfinvoke component="vpos" method="send" returnvariable="vpos_struct"
	monto="#form.monto#"
	moneda="CRC"
	origen="SACI"
	nombre="Adrián León Acuña"
	cuenta="10012365"
	correo="aleon@soin.co.cr"
	tipoTransaccion="VS"/>
<cflocation url="vpos-request.cfm?datos=#vpos_struct.datos#&validar=#vpos_struct.validar#" addtoken="no">--->


<cfinvoke component="vpos_respuesta" method="respuesta" returnvariable="respXML"
	PTid="327"/>
