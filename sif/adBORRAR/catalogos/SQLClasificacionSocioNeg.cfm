<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
<!--- INSERTADO DE REGISTRO ---->	
	<cfif isdefined("Form.Alta")>		
		<!---- Si son servicios ----->				
		<cfif isdefined ("form.tipo") and form.tipo EQ 'CCid'>

			<!---- Obtener todos los niveles que esten debajo del nivel seleccionado (si es el caso) ---->
			<cfif len(form.CCodigo) LT 5>
				<cfset form.CCcodigo = RepeatString('0', 5-len(trim(form.CCcodigo)) ) & trim(form.CCcodigo) >
			</cfif>
			
			<cfquery name="niveles" datasource="#session.DSN#" >
				select CCid,CCnivel 
				from CConceptos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CCpath like  '%#form.CCcodigo#%'
			</cfquery>			
			
			<!---- Insertar en la tabla del mantenimiento ----->
			<cfloop query="niveles">
				<cfquery name="rsExiste" datasource="#session.DSN#">
					select 1
					from ClasificacionItemsProv
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
						and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.CCid#">
				</cfquery>
								
				<cfif rsExiste.RecordCount GT 0>
					<cfset Request.Error.Backs = 1>
					<cf_errorCode	code = "50018" msg = "La clasificación ya ha sido asignada">
				<cfelse>		
					<cfquery name="insert" datasource="#Session.DSN#">
						insert into ClasificacionItemsProv (Ecodigo,SNcodigo,CCid,Ccodigo,nivel,BMUsucodigo,fechaalta,AClaId)
							values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#" >,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.CCid#" >,						
									null,
									<cfqueryparam cfsqltype="cf_sql_integer"   value="#niveles.CCnivel#" >,	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,						
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									null
									)	
					</cfquery>
				</cfif>
			</cfloop>
		<!---- Si son articulos -----> 
		<cfelseif isdefined("form.tipo") and form.tipo EQ 'Ccodigo'> 

			<!---- Obtener todos los niveles que esten debajo del nivel seleccionado (si es el caso) ---->
			<cfif len(form.Ccodigoclas) LT 5>
				<cfset form.Ccodigoclas = RepeatString('*', 5-len(trim(form.Ccodigoclas)) ) & trim(form.Ccodigoclas) >
			</cfif>
			
			<cfquery name="niveles" datasource="#session.DSN#" >
				select Ccodigo, Cnivel 
				from Clasificaciones
				where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and upper(Cpath) like  '%#form.Ccodigoclas#%'
			</cfquery>						
			
			<!---- Insertar en la tabla del mantenimiento ----->
			<cfloop query="niveles">				
				<cfquery name="rsExiste" datasource="#session.DSN#">
					select 1
					from ClasificacionItemsProv
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
						and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.Ccodigo#">
				</cfquery>
								
				<cfif rsExiste.RecordCount GT 0>
					<cfset Request.Error.Backs = 1>
					<cf_errorCode	code = "50018" msg = "La clasificación ya ha sido asignada">
				<cfelse>			
					<cfquery name="insert" datasource="#Session.DSN#">
						insert into ClasificacionItemsProv (Ecodigo,SNcodigo,CCid,Ccodigo,nivel,BMUsucodigo,fechaalta,AClaId)
							values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#" >,
									null,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.Ccodigo#" >,						
									<cfqueryparam cfsqltype="cf_sql_integer"   value="#niveles.Cnivel#" >,	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,						
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									null
								)	
					</cfquery>
				</cfif>	
			</cfloop>
		<cfelseif isdefined ("form.tipo") and form.tipo EQ 'AClaId'>
			<cfquery name="niveles" datasource="#session.DSN#" >
				select AClaId 
				from AClasificacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ACcodigodesc =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.ACcodigodescClas#">
			</cfquery>	
			
		
			<!---- Insertar en la tabla del mantenimiento ----->
			<cfloop query="niveles">
				<cfquery name="rsExiste" datasource="#session.DSN#">
					select 1
					from ClasificacionItemsProv
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
						and AClaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.AClaId#">
				</cfquery>			
							
				<cfif rsExiste.RecordCount GT 0>
					<cfset Request.Error.Backs = 1>
					<cfthrow message="El Activo ya ha sido Asignado">
					<!---<cf_errorCode	code = "50018" msg = "El Activo ya ha sido asignado">--->
				<cfelse>		
					<cfquery name="insert" datasource="#Session.DSN#">
						insert into ClasificacionItemsProv (Ecodigo,SNcodigo,CCid,Ccodigo,nivel,BMUsucodigo,fechaalta,AClaId)
							values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#" >,
								null,						
								null,
								null,	
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,						
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AClaId#" >
								)	
					</cfquery>
				</cfif>
			</cfloop>			
		</cfif>
		<cfset modo="CAMBIO">	
<!--- ELIMINAR REGISTRO ---->			
	<!---<cfelseif isdefined("Form.Baja")>---->
	<cfelseif isdefined("form.borrar")>

		<!--- Si son conceptos ---->		
		<cfif isdefined ("form.CCid") and form.CCid NEQ ''>
			<!--- Si se va a eliminar una carpeta ---->
			<cfquery name="rsPadre" datasource="#Session.DSN#">
				select CCid 
				from CConceptos 
				where CCidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#" >
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" > 
			</cfquery>
			<!--- Se eliminan los hijos de la carpeta --->
			<cfloop query="rsPadre">
				<!---- Si el hijo tiene mas hijos... ----->
				<cfquery name="rsPadre2" datasource="#Session.DSN#">
					select CCid 
					from CConceptos 
					where CCidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPadre.CCid#" >
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" > 
				</cfquery>
				<!--- Loop para eliminar los hijos del hijo.... ---->
				<cfloop query="rsPadre2">
					<cfquery name="delete" datasource="#Session.DSN#">			
						delete from ClasificacionItemsProv
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
							and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
							and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPadre2.CCid#">
					</cfquery>
				</cfloop>
				<!--- Eliminado de los hijos del padre... ----->
				<cfquery name="delete" datasource="#Session.DSN#">			
					delete from ClasificacionItemsProv
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
						and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPadre.CCid#">
				</cfquery>
			</cfloop>
			<!---- Se elimina el padre ----->
			<cfquery datasource="#Session.DSN#">
				delete from ClasificacionItemsProv
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
			</cfquery>
			
		<!--- Si son artículos ---->		
		<cfelseif isdefined ("form.Ccodigo") and form.Ccodigo NEQ ''>			
			<!--- Si se va a eliminar una carpeta ---->
			<cfquery name="rsPadre" datasource="#Session.DSN#">
				select Ccodigo 
				from Clasificaciones 
				where Ccodigopadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#" >
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" > 
			</cfquery>			
			<!--- Se eliminan los hijos de la carpeta --->
			<cfloop query="rsPadre">
				<!---- Si el hijo tiene mas hijos... ----->
				<cfquery name="rsPadre2" datasource="#Session.DSN#">
					select Ccodigo 
					from Clasificaciones 
					where Ccodigopadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPadre.Ccodigo#" >
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" > 
				</cfquery>
				<!--- Loop para eliminar los hijos del hijo.... ---->
				<cfloop query="rsPadre2">
					<cfquery name="delete" datasource="#Session.DSN#">			
						delete from ClasificacionItemsProv
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
							and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
							and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPadre2.Ccodigo#">
					</cfquery>
				</cfloop>	
				<!---- Eliminado de los hijos del padre... ----->
				<cfquery name="delete" datasource="#Session.DSN#">			
					delete from ClasificacionItemsProv
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
						and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPadre.Ccodigo#">
				</cfquery>
			</cfloop>
			<!---- Se elimina el padre ---->
			<cfquery datasource="#Session.DSN#">
				delete from ClasificacionItemsProv
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
			</cfquery>
				<cflocation url="ClasificacionSocioNeg.cfm?SNcodigo=#Form.SNcodigo#">

		<!---Si son Activos --->
		<cfelseif isdefined ("form.AClaId") and form.AClaId NEQ ''>	
			<cfquery datasource="#Session.DSN#">
				delete from ClasificacionItemsProv
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
			</cfquery>
		</cfif>		
		<cfset modo="ALTA">		
<!--- MODIFICAR REGISTRO ---->	
<!--- NO hay modificación de registros ----->
	</cfif>
	
</cfif>

<cfoutput>
<form action="ClasificacionSocioNeg.cfm" method="post" name="sql">
	<input type="hidden" name="modo" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input type="hidden" name="id" value="<cfif isdefined("Form.id") and modo NEQ 'ALTA'>#Form.id#</cfif>">
	<input type="hidden" name="SNcodigo" value="<cfif isdefined("Form.SNcodigo") and modo NEQ 'ALTA'>#Form.SNcodigo#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


