<cffunction name="eliminaTarPaq" output="false" returntype="void" access="public">
  <cfargument name="contrato" type="numeric" required="Yes"  displayname="IdContrato">
  <cfargument name="cuenta" type="numeric" required="Yes"  displayname="IdContrato">  

	<!---Elimimnacion de la tarea programada--->
	<cfquery name="rsTarea" datasource="#session.DSN#">
		select TPid, TPdescripcion
		from ISBtareaProgramada 
		where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.contrato#">
				and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuenta#">
				and TPestado = 'P'
				and TPtipo = 'RS'
	</cfquery>

	<cfif rsTarea.recordCount GT 0>
		<!---Datos del login--->
		<cfquery name="rsLogin" datasource="#session.DSN#">
			Select lo.LGnumero
				, lo.LGlogin
				, tp.TPdescripcion
			from ISBtareaProgramada tp
				inner join ISBlogin lo
					on lo.Contratoid=tp.Contratoid
						and lo.LGprincipal=1			
			where tp.TPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTarea.TPid#">
		</cfquery>	

		<cfinvoke component="saci.comp.ISBtareaProgramada" method="Baja">
			<cfinvokeargument name="TPid" value="#rsTarea.TPid#">
		</cfinvoke>

		<cfif isdefined('rsLogin') and rsLogin.recordCount GT 0>
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		<!---registro en la bitacora del borrado realizado --->
				<cfinvokeargument name="LGnumero" value="#rsLogin.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
				<cfinvokeargument name="BLautomatica" value="false">				
				<cfinvokeargument name="BLobs" value="Borrado Manual de Tarea Programada en Administración de Cuentas. (#rsLogin.TPdescripcion#)">
				<cfinvokeargument name="BLfecha" value="#now()#">
			</cfinvoke>			
		</cfif>			
	</cfif>
</cffunction>


<cfif isdefined("form.Retirar")>
	<cfquery name="rsPaquete" datasource="#session.DSN#">
		select	distinct PQcodigo
		from	ISBproducto
		where 	Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	</cfquery>

	
	<cfif isdefined("form.radio")>
		<cfif form.radio EQ 1>
			<cfinclude template="gestion-retiro-servicios-apply-tarea.cfm">	<!---retiro en una fecha determinada--->
		
		<cfelseif form.radio EQ 2>											<!---retiro en este momento--->					
			<cftransaction>
				<cfset eliminaTarPaq(form.pkg, form.cue)>
				<cfinvoke component="saci.comp.ISBproducto" method="RetirarProducto">
					<cfinvokeargument name="Contratoid" value="#form.pkg#">
					<cfinvokeargument name="fecha" value="#now()#">
					<cfinvokeargument name="MRid" value="#form.MRid#">
					<cfinvokeargument name="devolver" value="#IsDefined('form.devolucion')#">
				</cfinvoke>
			</cftransaction>			
		</cfif>	
	<cfelse>
		<cfthrow message="Error: no seleccionó si deseaba hacer el retiro en este momento o en un fecha determinada.">
	</cfif>
	
<cfelseif isdefined("form.Eliminar")>
	<cfset eliminaTarPaq(form.pkg, form.cue)>
</cfif>

<cfinclude template="gestion-redirect.cfm">
