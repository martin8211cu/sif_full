<!--- Verifica si el paquete requiere telefonos --->
<cfquery name="rsPaquete" datasource="#session.DSN#">
	select PQdescripcion, PQtelefono
	from ISBpaquete
	where  PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#"> 
</cfquery>

<!--- Obtener la cantidad máxima de logines que se pueden asignar por paquete --->
<cfquery name="maxServicios" datasource="#session.DSN#">
	select max(cant) as cantidad
	from (
		select coalesce(sum(SVcantidad), 0) as cant
		from ISBservicio
		where  PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#">
		 and Habilitado = 1
		group by TScodigo
	) temporal	
</cfquery>

<!--- Obtener los TScodigos permitidos por el paquete --->
<cfquery name="rsServiciosDisponibles" datasource="#session.DSN#">
	select a.TScodigo,a.SVcantidad,a.SVminimo
		, (select z.TSdescripcion from ISBservicioTipo z where z.TScodigo=a.TScodigo and z.Habilitado=1 and z.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) as descripcion
	from ISBservicio a
	where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#">
	and a.Habilitado = 1
	and a.TScodigo in (select x.TScodigo from ISBservicioTipo x where x.Habilitado=1 and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	order by TScodigo
</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>&nbsp;</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfoutput>
		<cfset loginesRepetidos = "">
		
		<form method="post" name="formRevLog" id="formRevLog" action="gestion.cfm">
			<input name="PQcodigo_n" type="hidden" value="<cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n))>#form.PQcodigo_n#</cfif>"/>
			<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
				<input name="LGnumero_#iLog#" type="hidden" value="<cfif isdefined("form.LGnumero_#iLog#") and len(trim(form["LGnumero_#iLog#"]))>#form['LGnumero_#iLog#']#</cfif>"/>					
				<input name="login_#iLog#" type="hidden" value="<cfif isdefined("form.login_#iLog#") and len(trim(form["login_#iLog#"]))>#form['login_#iLog#']#</cfif>"/>					
				<cfif rsPaquete.PQtelefono EQ 1>
						<input name="LGtelefono_#iLog#" type="hidden" value="<cfif isdefined("form.LGtelefono_#iLog#") and len(trim(form["LGtelefono_#iLog#"]))>#form['LGtelefono_#iLog#']#</cfif>"/>					
				</cfif>
				<cfloop query="rsServiciosDisponibles">
					<input name="chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#" type="hidden" value="<cfif isdefined("form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#") and len(trim(form["chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#"]))>#form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#']#</cfif>"/>					
				</cfloop>
				
				<!--- Verificar existencia de Login --->
				<cfif isdefined("form.login_#iLog#") and len(trim(form["login_#iLog#"]))>
					<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin">
						<cfinvokeargument name="LGlogin" value="#form['login_#iLog#']#">
						<cfif isdefined("form.LGnumero_#iLog#") and len(trim(form["LGnumero_#iLog#"]))>
							<cfinvokeargument name="LGnumero" value="#form['LGnumero_#iLog#']#">					
						</cfif>
					</cfinvoke>					
					<cfif ExisteLogin>
						<cfif len(trim(loginesRepetidos))>
							<cfset loginesRepetidos = loginesRepetidos & "," & form['login_#iLog#']>
						<cfelse>
							<cfset loginesRepetidos = form['login_#iLog#']>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>	
			
			<input name="CTid_n" type="hidden" value="<cfif isdefined("form.CTid_n") and len(trim(form.CTid_n))>#form.CTid_n#</cfif>"/>
			<cfinclude template="gestion-hiddens.cfm">
		</form>	
	
		<script language="javascript" type="text/javascript">
			var loginesOK = true;
			<cfif len(trim(loginesRepetidos))>
				loginesOK = false;
			</cfif>
		
			if(loginesOK){
				window.document.formRevLog.submit();		
			}else{
				alert('Error, los siguientes logines (#loginesRepetidos#) ya existen en el sistema, por favor, digite unos direfentes');
				document.formRevLog.adser.value = 2;			
				window.document.formRevLog.submit();
			}
		</script>
	</cfoutput>	
</body>
</html>