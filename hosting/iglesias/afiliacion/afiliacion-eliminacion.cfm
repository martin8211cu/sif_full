<!--- 
	Eliminación de Personas

	Antes
	1. Quita Rol a Usuario cuando tiene Usuario.
	2. Inactiva Usuario cuando no tiene mas Roles o solo le queda el de sys_public.
	3. Elimina terjetas de la Persona.
	4. Pone fecha del día a fecha fin en compromisos.
	5. Elimina la Persona si no tiene donaciones, si tiene donaciones la inactiva.
	
	Despues
	1. Inactiva Usuario cuando no tiene mas Procesos adicionales a los del sistema de IGL
	2. Elimina tarjetas de la Persona.
	3. Pone fecha del día a fecha fin en compromisos.
	4. Elimina la Persona si no tiene donaciones, si tiene donaciones la inactiva.
--->
<cfif isdefined("form.chk") and len(trim(form.chk)) gt 0>
	<cfset arrform_chk = listToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(arrform_chk)#" index="i">
		<cfif isnumeric(arrform_chk[i])>
			
			<cfinvoke 
			 component="home.Componentes.Seguridad"
			 method="getUsuarioByRef"
			 returnvariable="userdata">
				<cfinvokeargument name="referencia" value="#arrform_chk[i]#"/>
				<cfinvokeargument name="Ecodigo" value="#Session.EcodigoSDC#"/>
				<cfinvokeargument name="Tabla" value="MEPersona"/>
			</cfinvoke>
			
			<cfif userdata.RecordCount gt 0>
			
				<!--- 1. Inactiva Usuario cuando no tiene mas Procesos adicionales a los del sistema de IGL --->
				<cfquery name="rs1" datasource="asp">
					if not exists (	
						select 1 
						from UsuarioProceso
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#userdata.Usucodigo#">
						  and SScodigo <> 'IGL'
					) begin
						update Usuario
						set Uestado = 0,
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#session.Usucodigo#">,
							BMfecha = getDate()
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#userdata.Usucodigo#">
					end
				</cfquery>
				
			</cfif>
			
			<cfquery name="rs2" datasource="#Session.DSN#">
				--2. Elimina tarjetas de la Persona.
				
				delete MEDTarjetas
				where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
				
				--4. Pone fecha del día a fecha fin en compromisos.
				
				update MEDCompromiso 
				set MEDfechafin = getdate()
				where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
				
				--5. Elimina la Persona si no tiene donaciones, si tiene donaciones la inactiva.
				
				if not exists (
					select 1 
					from MEDDonacion
					where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
				)
				begin
					delete MERelacionFamiliar
					where MEpersona1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
					
					delete MERelacionFamiliar
					where MEpersona2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
					
					delete asp..UsuarioReferencia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
					and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arrform_chk[i]#">
					and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#userdata.Usucodigo#">
					and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="MEPersona">
					
					delete MEPersona
					where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
					
					select 1
				end
				else
				begin			
					update MEPersona 
					set activo = 0
					where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrform_chk[i]#">
				end
			</cfquery>
			
		</cfif>
	</cfloop>
</cfif>

<cfoutput>
<form action="afiliacion.cfm" method="post">
	<input type="hidden" name="chk" value="#Form.chk#">
	<input type="hidden" name="empr" value="#Form.empr#">
</form>
</cfoutput>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
