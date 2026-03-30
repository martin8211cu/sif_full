<cfoutput>
	<form method="get" name="form1" action="trafico.cfm?traf=trafico" style="margin:0" onSubmit="javascript: return validaFiltro(this);">
		<table  width="100%"cellpadding="2" cellspacing="0" border="0">		
			<tr>
				<td class="tituloAlterno" align="left">
					<table  id="table" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td align="right"><label><cf_traducir key="consultar">Consultar</cf_traducir> <cf_traducir key="por">por</cf_traducir></label></td>
							<td width="150">
								<select name="tipo"  id="tipo" tabindex="1" onchange="javascript: mostrarTipo();">
									<option value="1" <cfif isdefined("url.tipo") and url.tipo EQ 1>selected</cfif>>Cuenta-Login<!---<cf_traducir key="cuenta">Cuenta</cf_traducir>-<cf_traducir key="login">Login</cf_traducir>---></option>
									<option value="2" <cfif isdefined("url.tipo") and url.tipo EQ 2>selected</cfif>>Prepago<!---<cf_traducir key="prepago">Prepago</cf_traducir>---></option>
									<option value="3" <cfif isdefined("url.tipo") and url.tipo EQ 3>selected</cfif>>Medios<!---<cf_traducir key="medio">Medios</cf_traducir>---></option>
								</select>
							</td>
							<td id="login1" align="right"><label><cf_traducir key="cuenta">Cuenta</cf_traducir></label></td>
							<td id="login2">							
								<cfset valCuecue = "">
									<cfif isdefined('url.F_CUECUE') and len(trim(url.F_CUECUE))>
										<cfset valCuecue = url.F_CUECUE>
									</cfif>								
								<cf_campoNumerico name="F_CUECUE" decimales="-1" size="18" maxlength="15" value="#valCuecue#" tabindex="1">	
								<label><cf_traducir key="login">Login</cf_traducir></label>
								<input type="text" name="F_LGlogin" value="<cfif isdefined("url.F_LGlogin") and len(trim(url.F_LGlogin))>#url.F_LGlogin#</cfif>">
							</td>
							<td id="prepago1" align="right"><label><cf_traducir key="prepago">Prepago</cf_traducir></label></td>
							<td id="prepago2"align="left">		
								<cfset TJid="">
								<cfif isdefined("url.TJid")and len(trim(url.TJid))><cfset TJid = url.TJid></cfif>
								<cf_prepago
									id="#TJid#"
									form="form1">
							</td>
							<td id="medio1" align="right"><label><cf_traducir key="medio">Medio</cf_traducir></label></td>
							<td id="medio2">
								<cfset id="">
								<cfif isdefined("url.MDref")and len(trim(url.MDref))>		
									<cfset id = url.MDref>	
								</cfif>
								<cf_medio
									id="#id#">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="tituloAlterno">				
<!---							<label><cf_traducir key="login">&nbsp;</cf_traducir></label>
							<input name="fLGlogin" size="15" type="text" value="<cfif isdefined("url.fLGlogin")>#url.fLGlogin#</cfif>"/>
 --->
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td><label><cf_traducir key="desde">Desde</cf_traducir></label></td>
						<td><label><cf_traducir key="hasta">Hasta</cf_traducir></label></td>
						<td><label><cf_traducir key="tel">Tel&eacute;fono</cf_traducir></label></td>
						<td><label><cf_traducir key="dir">Direcci&oacute;n IP</cf_traducir></label></td>
						<td rowspan="2" align="center" valign="middle">
							<cf_botones names="Consultar" values="Consultar" tabindex="1">
						</td>
					  </tr>
					  <tr>
						<td>
							<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
								<cfset fdesde=url.fdesde>
							<cfelse>
								<cfset fdesde=LSDateFormat(now(),'dd/mm/yyyy')>
							</cfif>					
							<cf_sifcalendario form="form1" name="fdesde" value="#fdesde#">
						</td>
						<td>
							<cfif isdefined("url.fhasta") and len(trim(url.fhasta))>
								<cfset fhasta=url.fhasta>
							<cfelse>
								<cfset fhasta=LSDateFormat(now(),'dd/mm/yyyy')>
							</cfif>
							<cf_sifcalendario form="form1" name="fhasta" value="#fhasta#">
						</td>
						<td><input name="fEVtelefono" size="15" type="text" value="<cfif isdefined("url.fEVtelefono")>#url.fEVtelefono#</cfif>"/></td>
						<td><input name="fipaddr" size="15" type="text" value="<cfif isdefined("url.fipaddr")>#url.fipaddr#</cfif>"/></td>
					  </tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	
	<script language="javascript" type="text/javascript">
		function mostrarTipo()
		{
			var tipo = document.form1.tipo.value;
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
		function validaFiltro(f){
			if(f.tipo.value == 2 && f.TJlogin.value != ''){	//Por Prepago
				if(f.TJid.value == ''){
					alert('Error, la tarjeta de prepago esta vacia.');
					return false;
				}
			}
			
			return true;
		}
		
		mostrarTipo();
		
	</script>
</cfoutput>