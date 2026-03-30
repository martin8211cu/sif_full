<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader template="#session.sitio.template#" title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<cfif isdefined("URL.VerPopUp") and URL.VerPopUp eq 1>

				<cfset paramURL = "?BOTONSEL=" & URL.BOTONSEL>
				<cfset paramURL = paramURL & "&BTNAPLICAR=" & URL.BTNAPLICAR>
				<cfset paramURL = paramURL & "&CCONCEPTO=" & URL.CCONCEPTO>
				<cfset paramURL = paramURL & "&CHK=" & URL.CHK>
				<cfset paramURL = paramURL & "&EDOCUMENTO=" & URL.EDOCUMENTO>
				<cfset paramURL = paramURL & "&FIELDNAMES=" & URL.FIELDNAMES>
				<cfset paramURL = paramURL & "&GATMES=" & URL.GATMES>
				<cfset paramURL = paramURL & "&GATPERIODO=" & URL.GATPERIODO>
				
				<cfif isdefined("form.CDESCRIPCION")>
					<cfset paramURL = paramURL & "&CDESCRIPCION=" & form.CDESCRIPCION>
				</cfif>
				<cfif isdefined("form.ECODIGO")>			
					<cfset paramURL = paramURL & "&ECODIGO=" & form.ECODIGO>
				</cfif>
				<cfif isdefined("form.ESTADO")>			
					<cfset paramURL = paramURL & "&ESTADO=" & form.ESTADO>
				</cfif>
				<cfif isdefined("form.FILTRO_CDESCRIPCION")>			
					<cfset paramURL = paramURL & "&FILTRO_CDESCRIPCION=" & form.FILTRO_CDESCRIPCION>
				</cfif>
				<cfif isdefined("form.FILTRO_EDOCUMENTO")>			
					<cfset paramURL = paramURL & "&FILTRO_EDOCUMENTO=" & form.FILTRO_EDOCUMENTO>			
				</cfif>
				<cfif isdefined("form.FILTRO_ESTADO")>			
					<cfset paramURL = paramURL & "&FILTRO_ESTADO=" & form.FILTRO_ESTADO>
				</cfif>
				<cfif isdefined("form.FILTRO_GATPERIODO")>						
					<cfset paramURL = paramURL & "&FILTRO_GATPERIODO=" & form.FILTRO_GATPERIODO>
				</cfif>
				<cfif isdefined("form.FILTRO_MES")>			
					<cfset paramURL = paramURL & "&FILTRO_MES=" & form.FILTRO_MES>
				</cfif>
				<cfif isdefined("form.HFILTRO_CDESCRIPCION")>			
					<cfset paramURL = paramURL & "&HFILTRO_CDESCRIPCION=" & form.HFILTRO_CDESCRIPCION>
				</cfif>
				<cfif isdefined("form.HFILTRO_EDOCUMENTO")>			
					<cfset paramURL = paramURL & "&HFILTRO_EDOCUMENTO=" & form.HFILTRO_EDOCUMENTO>
				</cfif>
				<cfif isdefined("form.HFILTRO_ESTADO")>			
					<cfset paramURL = paramURL & "&HFILTRO_ESTADO=" & form.HFILTRO_ESTADO>
				</cfif>
				<cfif isdefined("form.HFILTRO_GATPERIODO")>			
					<cfset paramURL = paramURL & "&HFILTRO_GATPERIODO=" & form.HFILTRO_GATPERIODO>
				</cfif>
				<cfif isdefined("form.HFILTRO_MES")>
					<cfset paramURL = paramURL & "&HFILTRO_MES=" & form.HFILTRO_MES>
				</cfif>
				<cfif isdefined("form.IMG")>
					<cfset paramURL = paramURL & "&IMG=" & form.IMG>
				</cfif>
				<cfif isdefined("form.INACTIVECOL")>
					<cfset paramURL = paramURL & "&INACTIVECOL=" & form.INACTIVECOL>
				</cfif>
				<cfif isdefined("form.MES")>
					<cfset paramURL = paramURL & "&MES=" & form.MES>
				</cfif>
				<cfif isdefined("form.MODO")>
					<cfset paramURL = paramURL & "&MODO=" & form.MODO>
				</cfif>
				<cfif isdefined("form.PAGENUM")>
					<cfset paramURL = paramURL & "&PAGENUM=" & form.PAGENUM>
				</cfif>
				<cfif isdefined("form.STARTROW")>
					<cfset paramURL = paramURL & "&STARTROW=" & form.STARTROW>
				</cfif>				
				
				<script>			
					var PARAM  = "PreguntarAjuste.cfm<cfoutput>#paramURL#</cfoutput>"
					window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400')
				</script>
			</cfif>
			
			<cfinclude template="Conciliacion-common.cfm">			
			<cfif isdefined("form.GATperiodo") and len(trim(form.GATperiodo))
				and isdefined("form.GATmes") and len(trim(form.GATmes))
				and isdefined("form.Cconcepto") and len(trim(form.Cconcepto))
				and isdefined("form.Edocumento") and len(trim(form.Edocumento))
				and isdefined("form.Ocodigo") and len(trim(form.Ocodigo))
				and isdefined("form.CFcuenta") and len(trim(form.CFcuenta))>
				<cfinclude template="Conciliacion-encab.cfm">
				<cfinclude template="Conciliacion-encabdetalles.cfm">
				<cfinclude template="Conciliacion-detalles.cfm">
				<cfoutput>
				<form action="/cfmx/sif/af/gestion/operacion/Conciliacion.cfm" method="post" name="form1">
					<input type="hidden" name="GATperiodo" value="#form.GATperiodo#" />
					<input type="hidden" name="GATmes" value="#form.GATmes#" />
					<input type="hidden" name="Cconcepto" value="#form.Cconcepto#" />
					<input type="hidden" name="Edocumento" value="#form.Edocumento#" />
					<cf_botones values="Consultar Asiento, Consultar Transacciones, Lista" tabindex="1"
						names="btnConsultar_hecontables, btnConsultar_gatransacciones, btnLista">
				</form>
				<script language="javascript" type="text/javascript">
					<!--//
						function funcbtnConsultar_hecontables(){
							document.location.href="../consultas/consultaConciliacion-hecontablesRep.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#&Ocodigo=#Form.Ocodigo#&CFcuenta=#Form.CFcuenta#";
							return false;
						}
						function funcbtnConsultar_gatransacciones(){
							document.location.href="../consultas/consultaConciliacion-gatransaccionesRep.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#&Ocodigo=#Form.Ocodigo#&CFcuenta=#Form.CFcuenta#";
							return false;
						}
					//-->
				</script>
				</cfoutput>
			<cfelseif  isdefined("form.GATperiodo") and len(trim(form.GATperiodo))
				and isdefined("form.GATmes") and len(trim(form.GATmes))
				and isdefined("form.Cconcepto") and len(trim(form.Cconcepto))
				and isdefined("form.Edocumento") and len(trim(form.Edocumento))>
				<cfinclude template="Conciliacion-encab.cfm">
				<cfinclude template="Conciliacion-subtotales.cfm">
				<cfoutput>
				<form action="/cfmx/sif/af/gestion/operacion/Conciliacion-sql.cfm" method="post" name="form1">
					<input type="hidden" name="GATperiodo" value="#form.GATperiodo#" />
					<input type="hidden" name="GATmes" value="#form.GATmes#" />
					<input type="hidden" name="Cconcepto" value="#form.Cconcepto#" />
					<input type="hidden" name="Edocumento" value="#form.Edocumento#" />
					<cf_botones values="Conciliar, Consultar, Ir a Modificar, Ver Errores, Aplicar ,Lista" tabindex="1"
						names="btnConciliar, btnConsultar, btnModificar, btnVerErrores, btnAplicar, btnLista">
				</form>
				<script language="javascript" type="text/javascript">
					<!--//
						function funcbtnAplicar(){
							return confirm("¿Desea aplicar el movimiento?");
						}
						function funcbtnModificar(){
							document.location.href ="Transacciones.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#";
							return false;
						}
						function funcbtnConsultar(){
							document.location.href="../consultas/consultaConciliacion-subtotalesRep.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#";
							return false;
						}
						function funcbtnVerErrores(){
							var PARAM  = "ErroresConciliacion.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#"
							window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400')
							return false;
						}
					//-->
				</script>
				</cfoutput>
			<cfelseif  isdefined("form.btnContinuar") >
				<script language="javascript" type="text/javascript"> document.location.href="Conciliacion-sql.cfm?btnContinuar='Continuar'"; </script>
			<cfelse>
				<cfinclude template="Conciliacion-listadocs.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>