<!--- Generar Registro de Tracking y Asociarlo a la Orden de Compra --->
<cfinvoke 
 component="sif.Componentes.CM_GeneraTracking"
 method="generarNumTracking"
 returnvariable="idtracking">
	<cfinvokeargument name="CEcodigo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="EcodigoASP" value="#Session.EcodigoSDC#"/>
	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="cncache" value="#Session.DSN#"/>
	<cfinvokeargument name="EOidorden" value="#Form.EOidorden#"/>
	<cfinvokeargument name="verificarParamGeneracion" value="true"/>
	<cfinvokeargument name="verificarTrackingVacio" value="true"/>
</cfinvoke>
