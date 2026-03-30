<cfif isdefined("form.Bloquear")>
	<cftransaction>	
		<!---Agrega el registro de bloqueo--->
		<cfinvoke component="saci.comp.ISBbloqueoLogin" method="Alta">
			<cfinvokeargument name="LGnumero" value="#form.logg#">
			<cfinvokeargument name="MBmotivo" value="#form.MBmotivo#">
			<cfinvokeargument name="BLQdesde" value="#now()#">
			<cfinvokeargument name="BLQhasta" value="1-1-6100">
			<cfinvokeargument name="BLQdesbloquear" value="0">
		</cfinvoke>
	</cftransaction>
	
<cfelseif isdefined("form.Desbloquear")>
	
	<cfif isdefined("form.chk") and Listlen(form.chk)>
		<cftransaction>
			<!---Cierra el registro de bloqueo, actualizando el campo BLQdesbloquear y BLQhasta(fecha de desbloqueo) --->	
			<cfloop index="bid" list="#form.chk#" delimiters=",">
				<cfinvoke component="saci.comp.ISBbloqueoLogin"method="Desbloquear">
					<cfinvokeargument name="BLQid" value="#bid#">
					<cfinvokeargument name="BLQhasta" value="#now()#">
					<cfinvokeargument name="LGnumero" value="#form.logg#">
				</cfinvoke>
			</cfloop>
		</cftransaction>
	</cfif>
</cfif>
