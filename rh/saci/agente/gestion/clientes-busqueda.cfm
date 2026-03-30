<cfif isdefined("url.PidSinMask")and len(trim(url.PidSinMask))>
	<cfset url.Pid=url.PidSinMask>
</cfif>
<cfoutput>		
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="tituloAlterno"><td colspan="2" align="center">Busqueda de Clientes</td></tr>
	<tr class="tituloAlterno"><td width="60%">		
		<form method="get" name="form1" action="gestion.cfm" onsubmit="return validar(this);" style="margin:0">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr><td <!---colspan="2"--->>
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
					<td align="right">N° Cuenta&nbsp;</td>
					<td><input name="CUECUE" type="text" value="<cfif isdefined("url.CUECUE")and len(trim(url.CUECUE))>#url.CUECUE#</cfif>"/></td>
					<td align="right" width="108">Login &nbsp;</td>
					<td><input name="LGlogin" type="text" value="<cfif isdefined("url.LGlogin")and len(trim(url.LGlogin))>#url.LGlogin#</cfif>"/></td>
					<td align="right">Nombre&nbsp;</td>
					<td><input name="Pnombre" type="text" value="<cfif isdefined("url.Pnombre")and len(trim(url.Pnombre))>#url.Pnombre#</cfif>"></td>
					<td colspan="4"><cf_botones names="Buscar" values="Buscar"></td></tr>
			</table>
		</form>
		</td>
	</tr>
	<tr><td colspan="1">
			<cfif isdefined("url.Buscar")>
				<!---Variable para controlar los filtros--->
				<cfset paso=false>
				<!---Query para la Lista--->
				<cfquery datasource="#session.dsn#" name="rsConsulta">
					select distinct 
						a.Pquien as personaID,a.Pid, 
						a.Pnombre||' '|| a.Papellido||' '||a.Papellido2 as Pnombre
						,'2' as rol
						--,b.CTid,b.CUECUE,e.LGnumero, e.LGlogin
					from 	
						ISBpersona a
						inner join ISBcuenta b
							on b.Pquien =a.Pquien
							and  b.Habilitado=1
					<cfif isdefined("url.LGlogin") and len(trim(url.LGlogin))>
						inner join ISBproducto c
							on c.CTid =b.CTid
						inner join ISBlogin e
							on e.Contratoid =c.Contratoid
							and e.Habilitado=1
					</cfif>
					where
						<cfif isdefined("url.Pid") and len(trim(url.Pid))>
							a.Pid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Pid#">
							<cfset paso=true>
						</cfif>
						<cfif isdefined("url.Pnombre") and len(trim(url.Pnombre))>
							<cfif paso> and <cfelse><cfset paso=true></cfif> 
							upper(a.Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Pnombre))#%">
						</cfif>
						<cfif isdefined("url.CUECUE") and len(trim(url.CUECUE))>
							 <cfif paso> and <cfelse><cfset paso=true></cfif>
							 b.CUECUE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CUECUE#">
						</cfif>
						<cfif isdefined("url.LGlogin") and len(trim(url.LGlogin))>
							<cfif paso> and <cfelse><cfset paso=true></cfif>
							upper(e.LGlogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.LGlogin))#%">
						</cfif>
						order by a.Pid,Pnombre
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
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="No existen cuentas Definidas"/>
					<cfinvokeargument name="navegacion" value="Pid=#url.Pid#&Pnom=#url.Pnombre#&cuen=#url.CUECUE#&logi=#url.LGlogin#"/>
				</cfinvoke>
			</cfif>
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
			
			if(alguno == 0){
				alert("\n - Debe elegir al menos un criterio de búsqueda.");
				return false;
			}
			if (formulario.Pid.value != ""){
				eliminaMascara(); //esta funcion se encuentra dentro del tag de identificacion, y quita los '-','[' y ']' de la identificacion.
			}
			return true;
		 }
	</script>
</cfoutput>
	
