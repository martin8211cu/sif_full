<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfinclude template="actividades-params.cfm">

<cf_templateheader title="#nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfoutput>
			#pNavegacion#
			<form method="post" name="formFiltroActividades" action="#CurrentPage#" style="margin:0">	

				<table  width="100%"cellpadding="2" cellspacing="0" border="0" class="areaFiltro">
					<tr><td>
						<table  id="table" width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr>
								<td width="87" align="right" nowrap><label><cf_traducir key="consultar">Consultar</cf_traducir> <cf_traducir key="por">por</cf_traducir></label></td>
								<td width="148">
									<select name="tipo"  id="tipo" tabindex="1" onchange="javascript: mostrarTipo();">
										<option value="1" <cfif isdefined("form.tipo") and form.tipo EQ 1>selected</cfif>>Cuenta-Login</option>
										<option value="2" <cfif isdefined("form.tipo") and form.tipo EQ 2>selected</cfif>>Prepago</option>
										<option value="3" <cfif isdefined("form.tipo") and form.tipo EQ 3>selected</cfif>>Medios</option>
									</select>
								</td>
								<td width="59" align="right" id="login1"><label><cf_traducir key="login">Login</cf_traducir></label></td>
							<td width="209" id="login2">							
									<input type="text" name="F_LGlogin" value="<cfif isdefined("form.F_LGlogin") and len(trim(form.F_LGlogin))>#form.F_LGlogin#</cfif>">
								</td>
								<td width="112" align="right" id="prepago1"><label><cf_traducir key="prepago">Prepago</cf_traducir></label></td>
								<td width="2"align="left" id="prepago2">		
<!--- 									<cfset TJid="">
									<cfif isdefined("form.TJid")and len(trim(form.TJid))>
										<cfset TJid = form.TJid>
									</cfif>
									<cf_prepago
										id="#TJid#"
										form="formFiltroActividades"
										permNuevo="true"> --->
										<input type="text" name="TJlogin" value="<cfif isdefined("form.TJlogin") and len(trim(form.TJlogin))>#form.TJlogin#</cfif>">
								</td>
								<td width="59" align="right" id="medio1"><label><cf_traducir key="medio">Medio</cf_traducir></label></td>
								<td width="9" id="medio2">
<!--- 									<cfset id="">
									<cfif isdefined("form.MDref")and len(trim(form.MDref))>		
										<cfset id = form.MDref>	
									</cfif>
									<cf_medio
										form="formFiltroActividades"
										id="#id#"> --->
										<input type="text" name="MDref" value="<cfif isdefined("form.MDref") and len(trim(form.MDref))>#form.MDref#</cfif>">
								</td>
							</tr>
						</table>
			
					</td></tr>
					<tr><td>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td><label><cf_traducir key="desde">Desde</cf_traducir></label></td>
							<td><label><cf_traducir key="hasta">Hasta</cf_traducir></label></td>
							<td><label>Usuario</label></td>
							<td><label>Autom&aacute;tica</label></td>
							<td rowspan="2" align="center" valign="middle">
								<cf_botones names="Consultar" values="Consultar" tabindex="1">
							</td>
						  </tr>
						  <tr>
							<td>
								<cfif isdefined("form.fdesde") and len(trim(form.fdesde))>
									<cfset fdesde=form.fdesde>
								<cfelse>
									<cfset fdesde=LSDateFormat(now(),'dd/mm/yyyy')>
								</cfif>					
								<cf_sifcalendario form="formFiltroActividades" name="fdesde" value="#fdesde#">
							</td>
							<td>
								<cfif isdefined("form.fhasta") and len(trim(form.fhasta))>
									<cfset fhasta=form.fhasta>
								<cfelse>
									<cfset fhasta=LSDateFormat(now(),'dd/mm/yyyy')>
								</cfif>
								<cf_sifcalendario form="formFiltroActividades" name="fhasta" value="#fhasta#">
							</td>
							<td><input name="fUsuario" size="15" type="text" value="<cfif isdefined("form.fUsuario")>#form.fUsuario#</cfif>"/></td>
							<td><input type="checkbox" name="fChk_Automatica" <cfif isdefined("form.fChk_Automatica")> checked</cfif> value="1"></td>
						  </tr>
						</table>
					</td></tr>		
					<tr><td>&nbsp;</td></tr>						
				</table>
			</form>					
		</cfoutput>
		<cfif isdefined('form.Consultar')>
			<table width="100%"cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td>
						<cfinclude template="actividades-lista.cfm">
					</td>
				</tr>						
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	function mostrarTipo(){
		var tipo = document.formFiltroActividades.tipo.value;
		if (tipo==0){
			<!---document.getElementById('label1').style.display='';--->
			document.getElementById('login1').style.display='none';
			document.getElementById('login2').style.display='none';
			document.getElementById('prepago1').style.display='none';
			document.getElementById('prepago2').style.display='none';
			document.getElementById('medio1').style.display='none';
			document.getElementById('medio2').style.display='none';
		}
		if(tipo==1){
			<!---document.getElementById('label1').style.display='none';--->
			document.getElementById('login1').style.display='';
			document.getElementById('login2').style.display='';
			document.getElementById('prepago1').style.display='none';
			document.getElementById('prepago2').style.display='none';
			document.getElementById('medio1').style.display='none';
			document.getElementById('medio2').style.display='none';
		}
		if(tipo==2){
			<!---document.getElementById('label1').style.display='none';--->
			document.getElementById('login1').style.display='none';
			document.getElementById('login2').style.display='none';
			document.getElementById('prepago1').style.display='';
			document.getElementById('prepago2').style.display='';
			document.getElementById('medio1').style.display='none';
			document.getElementById('medio2').style.display='none';
		}
		if(tipo==3){
			<!---document.getElementById('label1').style.display='none';--->
			document.getElementById('login1').style.display='none';
			document.getElementById('login2').style.display='none';
			document.getElementById('prepago1').style.display='none';
			document.getElementById('prepago2').style.display='none';
			document.getElementById('medio1').style.display='';
			document.getElementById('medio2').style.display='';
		}
	}

	mostrarTipo();
</script>	