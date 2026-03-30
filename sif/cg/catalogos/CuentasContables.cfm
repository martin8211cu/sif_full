<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 3-2-2006.
		Motivo: se corrige la navegación que no estaba guardando los valores de los filtros.
--->


<cf_navegacion name="Cmayor"			default="">
<cf_navegacion name="Formato"			default="">
<cfset Lvarformato = Form.formato>
<cf_navegacion name="tipoMascara"		default="">
<cfset LvartipoMascara = Form.tipoMascara> 

<cf_navegacion name="F_Cformato"		session default="">
<cf_navegacion name="F_Cdescripcion"	session default="">
<cf_navegacion name="F_Cbalancen"	session default="">

	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templateheader title="Cuentas Contables">

            <!---<div align="center"><span class="superTitulo"><font size="5"><cfif isdefined("session.modulo") and session.modulo EQ "CG">Contabilidad 
              General <cfelseif isdefined("session.modulo") and session.modulo EQ "AD">Administración del Sistema</cfif></font></span></div></td>--->
      
            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas Contables'>
	

			<cfset navegacion = ''>
			<cfif isdefined ("form.tipoMascara") and len(trim(form.tipoMascara))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tipoMascara=" & form.tipoMascara>
			</cfif>
			<cfif isdefined ("form.Cmayor") and len(trim(form.Cmayor))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Cmayor=" & form.Cmayor>
			</cfif>
			
			<cfif isdefined ("form.Formato") and len(trim(form.Formato))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Formato=" & form.Formato>
			</cfif>

			<cfif isdefined ("form.F_Cformato") and len(trim(form.F_Cformato))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cformato=" & form.F_Cformato>
			</cfif>
			
			<cfif isdefined ("form.F_Cdescripcion") and len(trim(form.F_Cdescripcion))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cdescripcion=" & form.F_Cdescripcion>
			</cfif>
			
			<cfif isdefined ("form.F_Cbalancen") and len(trim(form.F_Cbalancen))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cbalancen=" & form.F_Cbalancen>
			</cfif>

			<cfset regresar = "javascript:CuentasM();">
			<cfif isdefined("session.modulo") and session.modulo EQ "CG">
				<cfinclude template="../../portlets/pNavegacionCG.cfm">
			<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
				<cfinclude template="../../portlets/pNavegacionAD.cfm">
			</cfif>
			
			<table width="100%" align="center" cellpadding="1" cellspacing="0">
			<tr>
				<td align="right" colspan="2"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Subcuentas.htm"></td>
			</tr>
            <tr>
                <td width="55%" align="center" valign="top"> 
					<cfset filtro = "">				
					<cfinclude template="filtroCuentasContables.cfm">
					
					<cfif isdefined('form.F_Cdescripcion') and form.F_Cdescripcion NEQ "">
						<cfset filtro = " and Upper(Cdescripcion) like upper('%" & #form.F_Cdescripcion# & "%')">
					</cfif>
					
					<cfif isdefined('form.F_Cformato') and form.F_Cformato NEQ "">
						<cfset filtro = filtro & " and Cformato like ('%" & #form.F_Cformato# & "%')">
					</cfif>					
					
					<cfif isdefined('form.F_Cbalancen') and form.F_Cbalancen NEQ "">
						<cfset filtro = filtro & " and Cbalancen = '" & #form.F_Cbalancen# & "'">
					</cfif>					
					
                    <cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
						<cfset Pagenum_lista = Form.Pagina>
					</cfif>
 					<cfif not isdefined("Form.Cmayor")>
						<cflocation addtoken="no" url="CuentasMayor.cfm">
					</cfif>

					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="CContables" 
						columnas="Ccuenta, 
							Cpadre, 
							Cformato, 
							case when CdescripcionF is null OR CdescripcionF = Cdescripcion then Cdescripcion else
								{fn concat( {fn concat( {fn concat( CdescripcionF , '<br>(' )},  Cdescripcion )}, ')' )} end as Cdescripcion,
							case 
								when Cbalancen = 'D' then 'Débito' 
								when Cbalancen = 'C' then 'Crédito'
								else 'Sin asignar'
							end as Cbalancen,
							Cmovimiento,
							Cmayor, 
							'#Lvarformato#' as formato,
							'#LvartipoMascara#' as tipoMascara" 
						desplegar="Cformato, Cdescripcion, Cbalancen, Cmovimiento"
						etiquetas="Cuenta, Descripción, Balance Normal,Ultimo Nivel<BR>(Acepta Movimien.)"
						ajustar="N,S,S,S"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo# and Cmayor='#Form.Cmayor#'  #filtro#  order by Cformato"
						align="left, left, center, center"
						checkboxes="N"
						keys="Ccuenta"
						showEmptyListMsg="true"
						maxRows="20"
						debug="N"
						navegacion="#navegacion#"
						ira="CuentasContables.cfm">
                  </cfinvoke>
				</td>
                <td width="45%" valign="top">
                  <cfinclude template="formCuentasContables.cfm">
				</td>
              </tr>
              <tr><td colspan="2">&nbsp;</td></tr>
            </table>
		<cf_web_portlet_end>
	<cf_templatefooter>