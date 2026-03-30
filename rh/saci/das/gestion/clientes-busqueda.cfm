<cfif isdefined("url.PidSinMask")and len(trim(url.PidSinMask))>
	<cfset url.Pid=url.PidSinMask>
</cfif>
<cfoutput>		
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="tituloAlterno"><td colspan="2" align="center">B&uacute;squeda de Clientes</td></tr>
	<tr class="tituloAlterno"><td width="60%">		
		<form method="get" name="form1" action="gestion.cfm" onsubmit="return validar(this);" style="margin:0">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr><td nowrap="nowrap">
						<cf_identificacion
						form = "form1"
						Ecodigo = "#session.Ecodigo#"
						Conexion = "#session.DSN#"
						onchangePersoneria = ""
						funcionValorEnBlanco = ""
						funcion = ""
						alignEtiquetas = "right"
						colspan = "0"
						incluyeTabla = "true"
						porFila = "true"
						ocultarPersoneria = "true"
						sufijo = ""
						id = ""
					>
					</td>
					<td align="right"><label>Nombre&nbsp;</label></td>
					<td><input name="Pnombre" type="text" value="<cfif isdefined("url.Pnombre")and len(trim(url.Pnombre))>#url.Pnombre#</cfif>"></td>
					<td align="right"><label>N°Cuenta&nbsp;</label></td>
					<td>
						<cfset valCueCue = "">
						<cfif isdefined("url.CUECUE") and len(trim(url.CUECUE))>
							<cfset valCueCue = HTMLEditFormat(Trim(url.CUECUE))>
						</cfif>

						<cf_campoNumerico 
							name="CUECUE" 
							decimales="-1"  nullable="yes"
							size="12" 
							maxlength="10" 
							value="#valCueCue#" 
							tabindex="1">
					</td>
					<td align="right"><label>Login&nbsp;</label></td>
					<td><input name="LGlogin" type="text" value="<cfif isdefined("url.LGlogin")and len(trim(url.LGlogin))>#url.LGlogin#</cfif>"/></td>
					<td><cf_botones names="Buscar" values="Buscar"></td></tr>
			</table>
		</form>
		</td>
	</tr>
	<tr><td colspan="1">

			<cfset naveg="">
			<cfif not isdefined("url.Pid")><cfset url.Pid = ""></cfif>
			<cfif not isdefined("url.Pnombre")><cfset url.Pnombre = ""></cfif>
			<cfif not isdefined("url.CUECUE")><cfset url.CUECUE = ""></cfif>
			<cfif not isdefined("url.LGlogin")><cfset url.LGlogin = ""></cfif>
			<cfset naveg="Pid=#url.Pid#&Pnom=#url.Pnombre#&cuen=#url.CUECUE#&logi=#url.LGlogin#">
			
			<!---Query para la Lista: Se restringe a 250 filas para evitar congestión en el servidor--->
			<cfquery datasource="#session.dsn#" name="rsConsulta" maxrows="250">
			set rowcount 250
				select distinct 
					a.Pquien as personaID
					, a.Pid
					, (a.Pnombre||' '|| a.Papellido||' '||a.Papellido2) as Pnombre
				from 	
					ISBpersona a
					<cfif Len(Trim(url.CUECUE)) Or Len(Trim(url.LGlogin))>
					inner join ISBcuenta b
						on b.Pquien =a.Pquien
						and  b.Habilitado=1
					</cfif>
						
					<cfif Len(Trim(url.LGlogin))>
					inner join ISBproducto c
						on c.CTid =b.CTid
						and c.CTcondicion not in ('C','0','X')<!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->	
					inner join ISBlogin e
						on e.Contratoid =c.Contratoid
						<!--- and e.Habilitado=1--->	
					</cfif>
						
				where 1=1
					<cfif isdefined("url.Pid") and len(trim(url.Pid))>
						and upper(a.Pid) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Pid))#%">
					</cfif>
					<cfif isdefined("url.Pnombre") and len(trim(url.Pnombre))>
						and upper(rtrim(a.Pnombre)||' '|| rtrim(a.Papellido)||' '||rtrim(a.Papellido2)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Pnombre))#%">
					</cfif>
					<cfif Len(Trim(url.CUECUE))>
						and b.CUECUE =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CUECUE#">
					</cfif>
					<cfif Len(Trim(url.LGlogin))>
						and upper(e.LGlogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.LGlogin))#%">
					</cfif>
					order by a.Pid,Pnombre
			set rowcount 0
			</cfquery>
			
			<!--- Lista --->
			<cfinvoke 
			 component="sif.Componentes.pListas" 
			 method="pListaQuery"
			 returnvariable="pListaAproCuentas">
				<cfinvokeargument name="Query" value="#rsConsulta#"/>
				<cfinvokeargument name="desplegar" value="Pid,Pnombre"/>
				<cfinvokeargument name="etiquetas" value="Identificación,Nombre"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="gestion.cfm"/>
				<cfinvokeargument name="conexion" value="#Session.DSN#"/>
				<cfinvokeargument name="keys" value="personaID"/>
				<cfinvokeargument name="formName" value="Lista"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="MaxRowsQuery" value="250"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="EmptyListMsg" value="No existen cuentas Definidas"/>
				<cfinvokeargument name="navegacion" value="#naveg#"/>
			</cfinvoke>
			
		</td>
		</tr>
	</table>	
			
	<script language="javascript" type="text/javascript">
		 function validar(formulario){
			var alguno = 0;
			if (formulario.Pid.value != "") alguno = 1;
			else if (formulario.CUECUE.value != "") alguno = 1;
			else if (formulario.LGlogin.value != "") alguno = 1;
			else if (formulario.Pnombre.value != "") alguno = 1;
			
			/*if(alguno == 0){
				alert("\n - Debe elegir al menos un criterio de búsqueda.");
				return false;
			}*/
			else{
				if ((formulario.CUECUE.value != "") && isNaN(formulario.CUECUE.value)){
					alert("\n - N°Cuenta debe ser un valor numérico entero.");
					return false;
				}			
			}
			
			if (formulario.Pid.value != ""){
				eliminaMascara(); //esta funcion se encuentra dentro del tag de identificacion, y quita los '-','[' y ']' de la identificacion.
			}
			return true;
		 }
	</script>
</cfoutput>
	
