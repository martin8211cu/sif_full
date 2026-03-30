<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 28 de junio del 2005
	Motivo:	corrección de error en la linea 105, el tipo de dato de la 
			consulta era integer en lugar de numeric
----------->
<cfif isdefined('url.Pagina')>
	<cfset form.Pagina = url.Pagina>
</cfif>
<cfif isdefined('url.Filtro_CDIdentificacion') and LEN(TRIM(url.Filtro_CDIdentificacion))>
	<cfset form.Filtro_CDIdentificacion=url.Filtro_CDIdentificacion>
</cfif>
<cfif isdefined('url.Filtro_CDnombre') and LEN(TRIM(url.Filtro_CDnombre))>
	<cfset form.Filtro_CDnombre=url.Filtro_CDnombre>
</cfif>
<cfif isdefined('url.Filtro_rotulo') and LEN(TRIM(url.Filtro_rotulo))>
	<cfset form.Filtro_rotulo=url.Filtro_rotulo>
</cfif>

<cfset params = ''>
<cfif isdefined('form.Pagina')>
	<cfset params = params & 'Pagina=#form.Pagina#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&Filtro_rotulo=#form.Filtro_rotulo#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&hFiltro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&hFiltro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&hFiltro_rotulo=#form.Filtro_rotulo#'>
</cfif>


<cfif isdefined('url.CDid') and url.CDid GT 0>
	<cfset form.CDid = url.CDid>
</cfif>
<!------>
<!--- Si el matenimiento es llamado desde la facturacion recibe una variable opcion=1 por url---->
<cfset modo = "ALTA">
<cfif isdefined("url.opcion") and url.opcion EQ 1>
	<cfset modo="ALTA">
</cfif>
<cfif isdefined('form.CDid') and form.CDid GT 0>
	<cfset modo = "CAMBIO">
</cfif>
<!--- <cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif isdefined("url.CDid") and not isdefined("form.CDid")>
	<cfset form.CDid = url.CDid>
	<cfset modo="CAMBIO">	
</cfif> --->

<cf_templateheader title="Datos Cliente">
	<cfif modo neq 'ALTA'>
		<cfquery name="rsClienteDetallista" datasource="#Session.DSN#" >
						Select CEcodigo ,CDid ,CDTid , CDactivo,
							case when CDactivo = 'P' then 'En Proceso' when CDactivo = 'A' then 'Aprobado' when CDactivo = 'R' then 'Rechazado' when CDactivo = 'I' then 'Inactivo' else 'No definido' end as rotulo, 
							
							CDidentificacion ,CDnombre ,CDapellido1 ,CDapellido2 ,CDdireccion1 ,CDdireccion2 ,CDpais, CDciudad  ,
							CDestado ,CDcodPostal ,CDoficina ,CDcasa ,CDcelular ,CDfax ,CDemail ,CDcivil ,CDfechanac ,CDingreso ,CDsexo, CDtrabajo ,CDantiguedad ,
							CDvivienda ,CDrefcredito ,CDrefbancaria ,CDestudios, CDdependientes, ts_rversion 
						from ClienteDetallista
						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
						and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		  
						order by CDidentificacion asc
					</cfquery>
					
					<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
						select 
							b.LPid, 
							b.LPdescripcion,
							a.SNcodigo, 
							a.ts_rversion
						from EListaPrecios b
							left outer join SNegocios a
								on a.Ecodigo = b.Ecodigo
								and a.LPid = b.LPid
								and a.CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >	
						where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by b.LPdescripcion
					</cfquery>
		<cfelse>
					<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
						select 
							b.LPid, 
							b.LPdescripcion,
							<cf_jdbcquery_param cfsqltype='cf_sql_integer' value='null'> as SNcodigo
						from EListaPrecios b
						where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by b.LPdescripcion
					</cfquery>	
		</cfif>
		

			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Clientes Detallistas'>
							
					<cfif isDefined("session.Ecodigo") and isDefined("Form.CDid") and len(trim(#Form.CDid#)) NEQ 0>
						<cfquery name="rsClienteDetallista" datasource="#Session.DSN#" >
							Select CEcodigo ,CDid ,CDTid , CDactivo,
								case when CDactivo = 'P' then 'En Proceso' when CDactivo = 'A' then 'Aprobado' when CDactivo = 'R' then 'Rechazado' when CDactivo = 'I' then 'Inactivo' else 'No definido' end as rotulo, 
								
								CDidentificacion ,CDnombre ,CDapellido1 ,CDapellido2 ,CDdireccion1 ,CDdireccion2 ,CDpais, CDciudad  ,
								CDestado ,CDcodPostal ,CDoficina ,CDcasa ,CDcelular ,CDfax ,CDemail ,CDcivil ,CDfechanac ,CDingreso ,CDsexo, CDtrabajo ,CDantiguedad ,
								CDvivienda ,CDrefcredito ,CDrefbancaria ,CDestudios, CDdependientes, ts_rversion 
							from ClienteDetallista
							where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
							and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		  
							order by CDidentificacion asc
						</cfquery>
					</cfif>
					<cfquery name="rsPais" datasource="asp" >
						select Ppais, Pnombre from Pais
					</cfquery>
					<cfquery name="rsPaisDefault" datasource="asp">
						select d.Ppais
						from CuentaEmpresarial ce
							join Direcciones d
								on d.id_direccion = ce.id_direccion
						where ce.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>
					<cfquery name="rsClienteDetallistaTipo" datasource="#Session.DSN#" >
						select CDTid, CDTdescripcion 
						from ClienteDetallistaTipo
						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>
					<script language="JavaScript" type="text/javascript" src="../../../js/utilesMonto.js">//</script>
				
					<script language="JavaScript" type="text/JavaScript">
						function funcRegresar() {
							<!-------->
							<cfif isdefined("form.opcion") and len(trim(form.opcion)) or (isdefined("url.opcion") and len(trim(url.opcion)))>							 
							   document.form.action='/cfmx/sif/fa/consultas/cons_art/carrito.cfm?CDid=#form.CDid#';
							<cfelse>
							   document.form.action='/cfmx/sif/cc/catalogos/clientes/Clientes.cfm?<cfoutput>#params#</cfoutput>';
							</cfif>
							document.form.submit();							
							<!-------->
						}
						<cfif modo neq 'ALTA'>
						function funcDocumentos() {
							location.href='Documentos.cfm?CDid=<cfoutput>#form.CDid#&#params#</cfoutput>';
							return false;
						}
						</cfif>
						</script>
					<script language="JavaScript" type="text/JavaScript">
					<!--
					function MM_findObj(n, d) { //v4.01
					  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
						d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
					  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
					  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
					  if(!x && d.getElementById) x=d.getElementById(n); return x;
					}
					
					function MM_validateForm() { //v4.0
					  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
					  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
						if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
						  if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
							if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
						  } else if (test!='R') { num = parseFloat(val);
							if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
							if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
							  min=test.substring(8,p); max=test.substring(p+1);
							  if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
						} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
					  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
					  document.MM_returnValue = (errors == '');
					}
					<!--
					
					function MM_preloadImages() { //v3.0
					  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
						var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
						if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
					}
					//-->
					
					function validar(form){
					
						if ( form.botonSel.value != 'Nuevo' && form.botonSel.value != 'Baja' && form.botonSel.value != 'Regresar'){
							MM_validateForm('CDidentificacion','','R','CDnombre','','R','CDapellido1','','R','CDfechanac','','R'); 
							if (document.MM_returnValue){ 
								document.form.CDidentificacion.disabled=false; 
								document.form.CDnombre.disabled=false; 
								document.form.CDapellido1.disabled=false; 
								document.form.CDapellido2.disabled=false; 
								document.form.CDfechanac.disabled=false; 
								document.form.CDingreso.value = qf(document.form.CDingreso.value);
								document.form.CDantiguedad.value = qf(document.form.CDantiguedad.value);
								document.form.CDdependientes.value = qf(document.form.CDdependientes.value);
								return document.MM_returnValue; 
							}
							else {
								return false;
							}
						}
						else{
							return true;	
						}	
					}
					
					function blur_cedula(ctl){
						var value = ctl.value;
						value = value.replace(/^([0-9])-([0-9]{3})-([0-9]{4})$/,'$1-0$2-$3');
						value = value.replace(/^([0-9])-([0-9]{4})-([0-9]{3})$/,'$1-$2-0$3');
						value = value.replace(/^([0-9])-([0-9]{3})-([0-9]{3})$/,'$1-0$2-0$3');
						value = value.replace(/^([0-9])([0-9]{3})([0-9]{3})$/,'$1-0$2-0$3');
						value = value.replace(/^([0-9])([0-9]{4})([0-9]{4})$/,'$1-$2-$3');
						ctl.value = value;
					}
					</script>
					

					<form action="SQLClientes.cfm" method="post" name="form" onSubmit="return validar(this);">						
						<cfoutput>
						<cfif isdefined('form.Pagina')>
							<input name="Pagina" type="hidden" value="#form.Pagina#" tabindex="-1">
						</cfif>
						<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
							<input name="Filtro_CDIdentificacion" type="hidden" value="#form.Filtro_CDIdentificacion#" tabindex="-1">
						</cfif>
						<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
							<input name="Filtro_CDnombre" type="hidden" value="#form.Filtro_CDnombre#" tabindex="-1	">
						</cfif>
						<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
							<input name="Filtro_rotulo" type="hidden" value="#form.Filtro_rotulo#" tabindex="-1">
						</cfif>
						</cfoutput>
						<cfif isdefined("url.opcion")>
						   <input name="opcion" type="hidden" value="1">
						   <!---<input name="insert" type="hidden" value="">--->
						</cfif>
						<table width="100%"  align="center" cellpadding="0" cellspacing="0">
							
							<tr>
								<td colspan="3" valign="top">
									<cfinclude template="../../../portlets/pNavegacionCC.cfm">
								</td>
							</tr>
						
							<tr> 
								<td colspan="3" align="center">
									<font size="3">
										<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
											Registro de Clientes
										</strong>
									</font>
								</td>
							</tr>	
							<cfif isDefined("session.Ecodigo") and isDefined("Form.CDid") and len(trim(#Form.CDid#)) NEQ 0> 
								<tr> 
									<td colspan="3" align="center">
										<font size="2">
											<strong> Cliente: </strong><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDidentificacion)# &nbsp; - &nbsp; #HTMLEditFormat(rsClienteDetallista.CDnombre)# &nbsp;#HTMLEditFormat(rsClienteDetallista.CDapellido1)# &nbsp;#HTMLEditFormat(rsClienteDetallista.CDapellido2)#</cfoutput>
									  </font>
								  </td>
								</tr>	
							</cfif>
						</table>
						<table width="80%"  align="center" cellpadding="0" cellspacing="0" > 
							<tr><td>&nbsp;</td></tr>
							<tr valign="top">
								<td width="40%">
									<cfinclude template="DatosClientesPersonales.cfm">
								</td>
								<td width="10%">&nbsp;</td>								
								<td width="40%">
									<cfinclude template="DatosClientesFisico.cfm">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr valign="top">
								<td width="40%">
									<cfinclude template="DatosClientesContacto.cfm">
								</td>
								<td width="10%">&nbsp;</td>
								<td width="40%">
									<cfinclude template="DatosClientesEconomicos.cfm">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr valign="top">
								<td width="40%"><fieldset> 
									<legend>Referencias Crediticias</legend>
									<cfinclude template="DatosClientesReferencias.cfm">
									</fieldset> 
								</td>
								<td width="10%">&nbsp;</td>
								<td width="40%"><fieldset> 
									<legend>Referencias Bancarias</legend>
									<cfinclude template="DatosClientesReferenciasB.cfm">
									</fieldset> 
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr> 
								<td align="center" nowrap colspan="3" >
									<cfif modo NEQ "ALTA">
										<cfset RD = ",Documentos">
										<cfset RDV = ",Registro de Documentos &gt;&gt;">
									<cfelse>
										<cfset RD = "">
										<cfset RDV = "">
									</cfif>
									<cf_botones modo="#modo#" include="Regresar#RD#" includevalues="Regresar#RDV#" tabindex="1">
								</td>
							</tr>
						</table>
							
							
							
						<cfset ts = "">
						  <cfif modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
								<cfinvokeargument name="arTimeStamp" value="#rsClienteDetallista.ts_rversion#"/>
							</cfinvoke>
						</cfif>  
						
						<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
						<input type="hidden" name="CDid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsClienteDetallista.CDid#</cfoutput></cfif>">
						
					</form>
					
					<script type="text/javascript">
					<!--
						function on_body_load() {
							document.form.CDnombre.focus();
						}
						document.body.onload = on_body_load;
					-->
					</script>
					
				<cf_web_portlet_end>

	<cf_templatefooter>