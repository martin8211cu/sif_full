<cfif isdefined("form.chk")>
	<cfloop list="#form.chk#" delimiters="," index="i">
		<cftransaction>
			<cfinvoke 
			 component="sif.Componentes.CM_GeneraTracking"
			 method="generarNumTracking"
			 returnvariable="idtracking">
				<cfinvokeargument name="CEcodigo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="EcodigoASP" value="#Session.EcodigoSDC#"/>
				<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
				<cfinvokeargument name="cncache" value="#Session.DSN#"/>
				<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
				<cfinvokeargument name="EOidorden" value="#i#"/>
				<cfinvokeargument name="verificarTrackingVacio" value="true"/>
			</cfinvoke>
		</cftransaction>
	</cfloop>
</cfif>

<cflocation url="generarTrackingOC.cfm">