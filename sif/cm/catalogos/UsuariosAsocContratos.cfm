<!--- Creado por: Rebeca Corrales Alfaro --->
<!--- Fecha: 22 de Julio, 2005           --->
<!--- Modificado por:                    --->
<!--- Fecha: 							 --->


<cf_templateheader title="Compras">
		<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Responsables a Notificar">
        	<cfinclude template="../../Utiles/sifConcat.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="55%" valign="top">
						<cfif isdefined('url.ECid') and not isdefined('form.ECid')>
							<cfparam name="form.ECid" default="#url.ECid#">
						</cfif>
						<cfset navegacion = "">
						<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid)) NEQ 0>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ECid=" & Form.ECid>
						</cfif>	
			  			<cfquery name="lista" datasource="#session.DSN#">
							select  a.CMClinea, a.Usucodigo as UsucodigoDel, c.Pid,  c.Pnombre#_Cat#' '#_Cat#c.Papellido1#_Cat#' '#_Cat#c.Papellido2 as usuario, '#Form.ECid#' as ECid,
							'<img border=''0'' onClick=''javascript: return eliminar("'#_Cat#<cf_dbfunction name="to_char" args="a.CMClinea">#_Cat#'");'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' as borrar
							from CMContratoNotifica a
								inner join Usuario b
									on a. Usucodigo = b.Usucodigo
								inner join DatosPersonales c
									on b.datos_personales = c.datos_personales
							where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
							order by usuario
						</cfquery>
						<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pListaQuery"
							 returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#lista#"/>
								<cfinvokeargument name="desplegar" value="Pid, usuario, borrar"/>
								<cfinvokeargument name="etiquetas" value=" Identificaci&oacute;n, usuario, "/>
								<cfinvokeargument name="formatos" value="V, V, S"/>
								<cfinvokeargument name="align" value=" left,left,left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value="UsuariosAsocContratos.cfm"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
								<cfinvokeargument name="maxrows" value="16"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="showLink" value="false"/>
						</cfinvoke>
					</td>
					<td>
						<cfoutput>
							<form name="form1" method="post" action="UsuariosAsocContratos-sql.cfm">
								<table width="40%" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<input type="hidden" name="ECid" value="#form.ECid#">
										<input type="hidden" name="CMClinea" value="">
										<td>
											<cf_sifusuarioE size="45">
										</td>
										<td>
											<input name="Agregar" type="submit" value="Agregar">
										</td>
										<td>
											<input name="Regresar" type="button" value="Regresar" onClick="javascript:Regresa();">
										</td>
									</tr>
								</table>
							</form>
						</cfoutput>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
<script language="JavaScript1.2" type="text/javascript">	
	//Funcion para eliminar un dato asigna al form de la lista los valores y lo envia
	function eliminar(CMClinea){
		if (confirm('Desea eliminar el Usuario?')) {
			document.form1.action = 'UsuariosAsocContratos-sql.cfm';			
			document.form1.CMClinea.value = CMClinea;
			document.form1.submit();			
		}
		return false;
	}
	function Regresa(){
		document.form1.action = 'contratos.cfm';
		document.form1.submit();			
	}
</script>