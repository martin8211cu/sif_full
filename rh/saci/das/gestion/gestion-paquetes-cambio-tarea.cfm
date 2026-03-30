<!-------------------------------------Pintado para modificar el paquete actual--------------------------------------->
<!--- Pintado de la seleccion hecha por el usuario de como quedara la tarea programada despues de terminar el proceso--->
<cfquery name="rsExistenServ" datasource="#session.DSN#">
		select distinct  c.LGnumero,c.TScodigo   
		from ISBproducto a
			inner join ISBlogin b
				on b.Contratoid=a.Contratoid
				and b.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
				and b.Habilitado=1
			inner join ISBserviciosLogin c
				on c.LGnumero=b.LGnumero
				and c.Habilitado=1
		where
			a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
			and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
</cfquery>
 
<!---Trae los logines del paquete actual para ser mostrados en pantalla--->
<cfquery name="rsServLog" datasource="#session.DSN#">
	select distinct  b.LGnumero,b.LGlogin,c.TScodigo   
	from ISBlogin b
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.Habilitado=1
			and c.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
	where
		b.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
		and b.Habilitado=1
</cfquery>



<!--- Se utiliza para eliminar los servicios de cablemodem cuando el cambio es de un paquete cable a un paquete no cable.--->
<!--- En éste caso no se debe mostrar la pantalla de verificación, el borrado del servicio debe hacerse de forma automática.--->
<cfinclude template="/saci/das/gestion/gestion-paquetes-sinverificar-logines-cruzados.cfm">

<!---selecciona los servicios por conservar que no fueron tomados en cuenta y los pone en una lista llamada: "servConservar" y a los logines que respectivamente pertenecen en la lista "logConservar". Ademas filtra por la lista loginMasBorrar que fue generada en "gestion-paquetes-verificar-logines-cruzados.cfm" para que no se tomen en cuenta los loguines inconsistentes que se encuentran en esta lista.--->
<cfinclude template="/saci/das/gestion/gestion-paquetes-servicios-sinTomar.cfm">

<!---Elimina de las listas los logines en memoria que presentan inconsistencias por que estan divididos entre diferentes listas (por ej: login1 esta en el la lista de logines por conservar y tambien esta en la lista de logines por borrar) y despues los agrega a la lista de los servicios por borrar. NOTA: se actualiza la lista de servicios por conservar no tomados en cuenta(logConservar y servConservar) en caso de que esten definidos. Deja en una lista llamada "loginMasBorrar" los logines que presentan inconsistencias --->
<cfset mensaje = -1>
<cfinclude template="/saci/das/gestion/gestion-paquetes-verificar-logines-cruzados.cfm">



<cfset arrLogC2 = logConservar>
<cfset arrSerC2 = servConservar>

<!---Trae el nombre del paquete actual--->
<cfquery name="rsPQanterior" datasource="#session.DSN#">
	select PQnombre
	from ISBpaquete 
	where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
	and Habilitado=1
</cfquery>

<!---Trae el nombre del paquete nuevo--->
<cfquery name="rsPQnuevo" datasource="#session.DSN#">
	select PQnombre,PQtelefono
	from ISBpaquete 
	where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
	and Habilitado=1
</cfquery>

<!---Verifica el nuevo paquete requiere o posee servicios de cable Modem--->
<cfquery name="rsCABM" datasource="#session.DSN#">
	select coalesce(sum(x.SVcantidad),0) as cant 
	from ISBservicio x 
	where x.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
		and x.TScodigo = 'CABM' 
		and x.Habilitado = 1
</cfquery>

<!---coloca los servicio por logines en arreglos para recorrerlos y mostrarlos en pantalla--->
<cfset arrLogC2 = ListToArray(arrLogC2)>												<!---por conservar no tomados en cuenta--->
<cfset arrSerC2 = ListToArray(arrSerC2)>

<cfset arrLogB = ListToArray(session.saci.cambioPQ.logBorrar.login,",")>				<!---por borrar--->
<cfset arrSerB = ListToArray(session.saci.cambioPQ.logBorrar.servicios,",")>

<cfset arrLogC = ListToArray(session.saci.cambioPQ.logConservar.login,",")>				<!---por conservar--->
<cfset arrSerC = ListToArray(session.saci.cambioPQ.logConservar.servicios,",")>

<cfset arrPqPA = ListToArray(session.saci.cambioPQ.pqAdicional.cod,",")>				<!---paquetes adicionales--->
<cfset arrLogPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.login,",")>
<cfset arrSerPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.servicios,",")>

<cfif rsPQnuevo.PQtelefono EQ 1>
	<cfset span = 3>
	<cfset anch = "33%">
<cfelse>
	<cfset span = 2>
	<cfset anch = "50%">
</cfif>


<cfoutput>
	<cfif rsExistenServ.recordCount NEQ 0>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">	  
			<cfif mensaje NEQ -1>
			<tr><td colspan="#span#" align="center"><font style="color:##FF0000">El servicio #servMasBorrar# del login #loginMasBorrar# ser&aacute; borrado porque no puede existir un mismo login para paquetes separados.</font></td></tr>	
			</cfif>
			<!---Paquete Actual --->
			<tr class="tituloAlterno"><td colspan="#span#">Configuraci&oacute;n del Paquete Actual</td></tr>
			<tr><td colspan="#span#">
					<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
					&nbsp;#session.saci.cambioPQ.PQanterior#-#rsPQanterior.PQnombre#
				</td>
			</tr>
			<!---Etiquetas--->
			<cfif rsServLog.RecordCount GT 0>
				<tr><td width="#anch#"><label><cf_traducir key="login">Login</cf_traducir></label></td><td width="#anch#"><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td> <cfif rsPQnuevo.PQtelefono EQ 1><td width="#anch#">&nbsp;</td></cfif></tr>
				<cfloop  query="rsServLog">
					<tr><td>#rsServLog.LGlogin#</td><td>#rsServLog.TScodigo#</td></tr>
				</cfloop>
			</cfif>  
			<!---Paquete Nuevo --->
			<tr class="tituloAlterno"><td colspan="#span#">Configuraci&oacute;n del(os) Nuevo(s) Paquete(s)</td></tr>
						
			<!---Paquetes Nuevos--->
			<tr><td colspan="#span#">
					<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
					&nbsp;#session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#
				</td>
			</tr>
			<!---Campos de Subscriptor--->
			<cfif rsCABM.cant GT 0>
				<tr><td align="left"><label>Suscriptor</label>
						<input type="text" name="CNsuscriptor" size="25" maxlength="50" value="" tabindex="1" />
					</td>
					<td align="left"><label>No.Suscriptor</label>
						<input type="text" name="CNnumero" size="22" maxlength="20" value="" tabindex="1" />
					</td>
					<cfif rsPQnuevo.PQtelefono EQ 1><td>&nbsp;</td></cfif>
				</tr>
			</cfif>

			<!---Servicios por conservar --->
			<cfset logAct = "">
			<cfset listTel = "">
			<cfif ArrayLen(arrLogC)>
				<!---Etiquetas--->						
				<tr>
					<td width="#anch#"><label><cf_traducir key="login">Login</cf_traducir></label></td><td width="#anch#"><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
					<cfif rsPQnuevo.PQtelefono EQ 1>
					<td width="#anch#"><label><cf_traducir key="tel">Tel&eacute;fono</cf_traducir></label></td>
					</cfif>
				</tr>
				
				<!---Campos--->
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogC)#">
					<tr><td>#arrLogC[cont]#</td>
						<td>#arrSerC[cont]#</td>
						<cfif rsPQnuevo.PQtelefono EQ 1>
							<cfif logAct NEQ arrLogC[cont]><cfset logAct = arrLogC[cont]>
							<cfset listTel = listTel & IIF(len(trim(listTel)),DE(','),DE(''))&logAct>
							<td><cf_campoNumerico name="LGtelefono#arrLogC[cont]#" decimales="-1" size="12" maxlength="15" value="" tabindex="1"></td>
							</cfif>
						</cfif>
					</tr>
				</cfloop>
			</cfif>
			
			<!---Servicios por conservar faltantes--->
			<cfif ArrayLen(arrLogC2)>
				<!---Etiquetas--->
				<cfif not ArrayLen(arrLogC)>						
					<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
					<cfif rsPQnuevo.PQtelefono EQ 1>
						<td><label><cf_traducir key="tel">Tel&eacute;fono</cf_traducir></label></td>
					</cfif>
					</tr>
				</cfif>
				<!---Campos--->
				<cfset logAct="">
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogC2)#">
					<tr><td>#arrLogC2[cont]#</td>
						<td>#arrSerC2[cont]#</td>
						<cfif rsPQnuevo.PQtelefono EQ 1>
							<cfset listLogin=session.saci.cambioPQ.logConservar.login>
							<cfif logAct NEQ arrLogC2[cont] and ListFindNoCase(listLogin,logAct,',') EQ 0>	<!---imprime telefono solo una vez por login(para los logines con servicio de acceso), y asi que que si el telefono ya se imprimio en los logines por conservar no debe imprimirse en los logines por conservar que no fueron tomados en cuenta --->
								<cfset logAct = arrLogC2[cont]>
								<cfset listTel = listTel & IIF(len(trim(listTel)),DE(','),DE(''))&logAct>
								<td><cf_campoNumerico name="LGtelefono#arrLogC2[cont]#" decimales="-1" size="12" maxlength="15" value="" tabindex="1"></td>
							</cfif>
						</cfif>
					</tr>
				</cfloop>
			</cfif>
			
			<cfset listaSufijos="_" & session.saci.cambioPQ.PQnuevo>
			<!---Paquetes Adicionales--->
			<cfif ArrayLen(arrPqPA)>			
				<cfset pqAct="">
				<cfset index="1">
				
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrPqPA)#">	
					<cfif pqAct NEQ arrPqPA[cont]>
						<cfset pqAct=arrPqPA[cont]>
						<cfif len(trim(listaSufijos))>
							<cfset listaSufijos=listaSufijos & ',_' & pqAct>						
						<cfelse>
							<cfset listaSufijos='_' & pqAct>
						</cfif>
						
						<cfquery name="rsPQadicional" datasource="#session.DSN#">
							select PQnombre
							from ISBpaquete 
							where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#pqAct#">
							and Habilitado=1
						</cfquery>
						<tr><td colspan="#span#">
								<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
								&nbsp;#pqAct#-#rsPQadicional.PQnombre#
							</td>
						</tr>
						<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td><cfif rsPQnuevo.PQtelefono EQ 1><td>&nbsp;</td></cfif></tr>
					</cfif>
					<tr><td>#arrLogPA[index]#</td><td>#arrSerPA[index]#</td><cfif rsPQnuevo.PQtelefono EQ 1><td>&nbsp;</td></cfif></tr>
					
					<cfset index=index+1>
				</cfloop>
			</cfif>
		</table>
	</cfif>

<script type="text/javascript" language="javascript">
	function validarSupcriptor(f){
		var ret=true;
		if (#rsCABM.cant# > 0){
			if(f.CNsuscriptor.value =="")ret=false;
			if(f.CNnumero.value =="")ret=false;
		}
		return(ret);
	}
	
	function validarTelefono(f){
		var mens="";
		if (#rsPQnuevo.PQtelefono# == 1){
			<cfloop index="lo" list="#listTel#" delimiters=",">
				if(eval("document.form1.LGtelefono#lo#.value") == ""){
					mens += "\n - Debe digitar el teléfono para el login #lo#";
				}
			</cfloop>
		}
		return(mens);
	}
</script>

</cfoutput>