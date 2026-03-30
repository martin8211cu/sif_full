<!---<cfabort showerror="MIRA">--->
<cfif isdefined("Form.id_root_default") and Form.id_root_default NEQ "">
	<cfif Form.id_root_default EQ "-1">
		<cfquery datasource="asp">
			update SRolMenu
			   set default_menu = 0
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SScodigo#" null="#Len(Form.SScodigo) Is 0#">
			   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SRcodigo#" null="#Len(Form.SRcodigo) Is 0#">
		</cfquery>
	<cfelse>
		<cfquery datasource="asp">
			update SRolMenu
			   set default_menu = 1
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SScodigo#" null="#Len(Form.SScodigo) Is 0#">
			   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SRcodigo#" null="#Len(Form.SRcodigo) Is 0#">
			   and id_root 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_root_default#" null="#Len(Form.id_root_default) Is 0#">
		</cfquery>
		<cfquery datasource="asp">
			update SRolMenu
			   set default_menu = 0
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SScodigo#" null="#Len(Form.SScodigo) Is 0#">
			   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SRcodigo#" null="#Len(Form.SRcodigo) Is 0#">
			   and id_root 	<> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_root_default#" null="#Len(id_root_default) Is 0#">
		</cfquery>
	</cfif>
<cfelseif isdefined("Form.id_root_borrar") and Form.id_root_borrar NEQ "">
	<cfquery datasource="asp">
		delete from SRolMenu
		 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SScodigo#" null="#Len(Form.SScodigo) Is 0#">
		   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SRcodigo#" null="#Len(Form.SRcodigo) Is 0#">
		   and id_root 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_root_borrar#" null="#Len(Form.id_root_borrar) Is 0#">
	</cfquery>
<cfelseif not isdefined("Form.btnNuevo")>
	<!--- procesa la imagen --->
	<cfif isdefined("form.btnAgregar") or isdefined("form.btnCambiar")>
		<cfif isdefined("form.logo") and Len(Trim(form.logo)) gt 0 >
			<cfinclude template="../../utiles/imagen.cfm">
		</cfif>
	</cfif>

	<cfif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0 and isdefined("Form.SRcodigo") and Len(Trim(Form.SRcodigo)) NEQ 0>
		<cfif isdefined("Form.btnEliminar")>
			<cfquery name="rs" datasource="asp">
				delete UsuarioRol
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
			</cfquery>
			<cfquery name="rs" datasource="asp">
				delete SRoles
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
				  <!---
				  and SScodigo != 'sys'
				  and SRcodigo != 'anonymous'
				  --->
			</cfquery>
			<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
				method="actualizar">
				<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
			</cfinvoke>
		<cfelse>
			<cfquery name="rs" datasource="asp">
				update SRoles
				   set SRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRdescripcion#">,
				       SRinterno = <cfqueryparam cfsqltype="cf_sql_bit" value="#isdefined('form.SRinterno')#">
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
				  <!---
				  and SScodigo != 'sys'
				  and SRcodigo != 'anonymous'
				  --->
			</cfquery>
			<cfif form.SRcodigo neq form.SRcodigo_text>
				<cftransaction>
				<cfquery name="rs" datasource="asp">
					insert into SRoles (SScodigo, SRcodigo, SRdescripcion, SRinterno, BMfecha, BMUsucodigo)
					select SScodigo,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo_text#"> SRcodigo,
						SRdescripcion, SRinterno, BMfecha, BMUsucodigo
					from SRoles 
					where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
				</cfquery>
				<cfquery name="rs" datasource="asp">
					update SProcesosRol
					set SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo_text#">
					where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
				</cfquery>
				<cfquery name="rs" datasource="asp">
					update UsuarioRol
					set SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo_text#">
					where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
				</cfquery>
				<cfquery name="rs" datasource="asp">  
					delete SRoles
					where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
				</cfquery>
				</cftransaction>
				<cfset form.SRcodigo = form.SRcodigo_text>
			</cfif>
		</cfif>
		
        <!--- ACTUALIZA LOS PROCESOS ASIGNADOS AL ROL DE ACUERDO A LA LISTA --->
        <!---BORRA LOS PROCESOS DESMARCADOS--->
		<cfif isdefined("form.procesos_borrar") and len(trim(form.procesos_borrar)) gt 1>
			<!--- procesos_borrar puede traer datos repetidos, esto implica que va a 
                  ir varias veces a la bd con un mismo dato. La idea es eliminar los 
                  datos repetidos para evitar lo anterior.
            --->
            <cfset arreglo = ListToArray(form.procesos_borrar,'*') >
            <cfset ya_borrados = ''>
            <cfloop index="i" from="1" to="#ArrayLen(arreglo)#" >
				<cfset arreglo2 = ListToArray(arreglo[i],'|')>
                <cfif ArrayLen(arreglo2) EQ 4>
                	<cfset ya_borrado_pk = arreglo2[1]&'|'&arreglo2[2]&'|'&arreglo2[3]&'|'&arreglo2[4]>
                <cfelse>
                	<cfset ya_borrado_pk = arreglo2[1]&'|'&arreglo2[2]&'|'&arreglo2[3]&'|N/A'>
                </cfif>
                <cfif Not ListFind(ya_borrados, ya_borrado_pk)>
					<cfset ya_borrados = ListAppend(ya_borrados, ya_borrado_pk)>
                    <cfquery name="delete" datasource="asp">
                        delete from SProcesosRol
                        where 1=1
                        	and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
                          	and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
                          	and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arreglo2[3]#">
							  <cfif ArrayLen(arreglo2) EQ 4>
                                and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arreglo2[4]#">
                              </cfif>
                    </cfquery>
                </cfif>
            </cfloop>
		</cfif>
        <!---AGREGA LOS PROCESOS MARCADOS--->
        <cfif isdefined("form.permisos")>
            <cfloop index = "index" list = "#Form.permisos#" delimiters = ",">
                <cfset data = ListToArray(index,'|') >
				<cfquery name="rsVerifica" datasource="asp">
                	select 1 
                    from SProcesosRol
                    where 1=1 
                    and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SRcodigo#">
                   	and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
                    and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
					and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
                </cfquery>
                <cfif isdefined("rsVerifica") and rsVerifica.recordcount EQ 0>
                	<cfquery name="rs" datasource="asp">
                        insert into SProcesosRol ( SScodigo, SMcodigo, SPcodigo, SRcodigo, BMUsucodigo, BMfecha )
                        values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
                                 <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">,
                                 <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">,
                                 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">,
                                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                                 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                               )
                    </cfquery>
                </cfif>
			</cfloop>
        </cfif>                
	<cfelseif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0 and isdefined("Form.SRcodigo_text") and Len(Trim(Form.SRcodigo_text)) NEQ 0>
		<cfquery name="rs" datasource="asp">
			insert into SRoles (SScodigo, SRcodigo, SRdescripcion, SRinterno, BMUsucodigo, BMfecha)
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo_text#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_bit" value="#isdefined('form.SRinterno')#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				   )
		</cfquery>
	</cfif>
</cfif>	

<cfoutput>
	<form action="<cfif isdefined("form.btnProcesos")>procesos-rol.cfm<cfelse>roles.cfm</cfif>" method="post" name="sql">
			<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
			<cfif isdefined("form.fSScodigo")>
				<input type="hidden" name="fSScodigo" value="#form.fSScodigo#">
			</cfif>
			<cfif isdefined("Form.fSRcodigo")>
				<input type="hidden" name="fSRcodigo" value="#form.fSRcodigo#">
			</cfif>
			<cfif isdefined("Form.fSRdescripcion")>
				<input type="hidden" name="fSRdescripcion" value="#Form.fSRdescripcion#">
			</cfif>
			<cfif not isdefined("Form.btnNuevo") and not isdefined("Form.btnEliminar")>
				<input type="hidden" name="SScodigo" value="#form.SScodigo#">
				<input type="hidden" name="SRcodigo" value="#form.SRcodigo_text#">
			</cfif>
			<cfif isdefined("form.btnProcesos") and len(trim(form.btnProcesos)) gt 0>
				<cfif not isdefined("form.fSScodigo")><input type="hidden" name="FSScodigo" value="#Form.SScodigo#"></cfif>
				<cfif not isdefined("form.fSRcodigo")><input type="hidden" name="FSRcodigo" value="#Form.SRcodigo#"></cfif>
			</cfif>
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>