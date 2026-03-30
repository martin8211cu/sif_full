<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 24-1-2006.
		Motivo: Actualizar. Utilización del componente de listas, cf_botones, cf_qforms.
 --->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<!--- Aqui se incluye el form --->
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>	
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>					
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<cfif isdefined("url.Filtro_RHnombre") and not isdefined("form.Filtro_RHnombre")>
				<cfset "form.Filtro_RHnombre"  ="#url.Filtro_RHnombre#">
			</cfif>
			<cfif isdefined("url.Filtro_RHPid") and not isdefined("form.Filtro_RHPid")>
				<cfset "form.Filtro_RHPid"  ="#trim(url.Filtro_RHPid)#">
			</cfif>		
			<cfif isdefined("url.filtrado") and not isdefined("form.filtrado")>
				<cfset "form.filtrado"  ="#url.filtrado#">
			</cfif>	
			<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar")>
				<cfset "form.btnFiltrar"  ="#url.btnFiltrar#">
			</cfif>
			
			<cfif isdefined("url.Filtro_Tipo") and not isdefined("form.Filtro_Tipo")>
				<cfset "form.Filtro_Tipo"  ="#url.Filtro_Tipo#">
			</cfif>
			<cfif isdefined("url.Filtro_Pmail1") and not isdefined("form.Filtro_Pmail1")>
				<cfset "form.Filtro_Pmail1"  ="#trim(url.Filtro_Pmail1)#">
			</cfif>		
			<cfif isdefined("url.Filtro_Pcasa") and not isdefined("form.Filtro_Pcasa")>
				<cfset "form.Filtro_Pcasa"  ="#url.Filtro_Pcasa#">
			</cfif>	
			
			<cfif isdefined("url.Filtro_Poficina") and not isdefined("form.Filtro_Poficina")>
				<cfset "form.Filtro_Poficina"  ="#url.Filtro_Poficina#">
			</cfif>
			<cfif isdefined("url.Filtro_Pcelular") and not isdefined("form.Filtro_Pcelular")>
				<cfset "form.Filtro_Pcelular"  ="#trim(url.Filtro_Pcelular)#">
			</cfif>		
			<cfif isdefined("url.Filtro_Pmail2") and not isdefined("form.Filtro_Pmail2")>
				<cfset "form.Filtro_Pmail2"  ="#url.Filtro_Pmail2#">
			</cfif>	
			
			<cfif isdefined("url.Filtro_Pagertel") and not isdefined("form.Filtro_Pagertel")>
				<cfset "form.Filtro_Pagertel"  ="#url.Filtro_Pagertel#">
			</cfif>
			<cfif isdefined("url.Filtro_Pagernum") and not isdefined("form.Filtro_Pagernum")>
				<cfset "form.Filtro_Pagernum"  ="#trim(url.Filtro_Pagernum)#">
			</cfif>		
			<cfif isdefined("url.Filtro_Pfax") and not isdefined("form.Filtro_Pfax")>
				<cfset "form.Filtro_Pfax"  ="#url.Filtro_Pfax#">
			</cfif>	
			
			<cfif isdefined("url.persona") and not isdefined("form.persona")>
				<cfset "form.persona"  ="#url.persona#">
			</cfif>
			
			<cfif isdefined("url.sel") and not isdefined("form.sel") and isdefined("url.PageNum_lista")>
				<cfset "form.sel"  ="0">
			<cfelseif isdefined("url.sel") and not isdefined("form.sel")>
				<cfset "form.sel"  ="#url.sel#">
			</cfif>	

			<cfset regresar = "">
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "listaRH.cfm?">
			<cfif isdefined('Form.Pagina') and LEN(TRIM(Form.Pagina))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Pagina=" & Form.Pagina>
			</cfif>
			<cfif isdefined('Form.persona') and LEN(TRIM(Form.persona))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "persona=" & Form.persona>
			</cfif>
			<cfif isdefined('Form.sel') and LEN(TRIM(Form.sel))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
			</cfif>
			<cfif isdefined('Form.Filtro_RHnombre') and LEN(TRIM(Form.Filtro_RHnombre))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_RHnombre=" & Form.Filtro_RHnombre>
			</cfif>
			<cfif isdefined('Form.Filtro_RhPid') and LEN(TRIM(Form.Filtro_RhPid))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_RhPid=" & Form.Filtro_RhPid>
			</cfif>
			<cfif isdefined('Form.Filtro_Tipo') and LEN(TRIM(Form.Filtro_Tipo))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Tipo=" & Form.Filtro_Tipo>
			</cfif>
			<cfif isdefined('Form.Filtro_Pmail1') and LEN(TRIM(Form.Filtro_Pmail1))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pmail1=" & Form.Filtro_Pmail1>
			</cfif>
			<cfif isdefined('Form.Filtro_Pcasa') and LEN(TRIM(Form.Filtro_Pcasa))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pcasa=" & Form.Filtro_Pcasa>
			</cfif>
			<cfif isdefined('Form.Filtro_Poficina') and LEN(TRIM(Form.Filtro_Poficina))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Poficina=" & Form.Filtro_Poficina>
			</cfif>
			<cfif isdefined('Form.Filtro_Pcelular') and LEN(TRIM(Form.Filtro_Pcelular))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pcelular=" & Form.Filtro_Pcelular>
			</cfif>
			<cfif isdefined('Form.Filtro_Pmail2') and LEN(TRIM(Form.Filtro_Pmail2))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pmail2=" & Form.Filtro_Pmail2>
			</cfif>
			<cfif isdefined('Form.Filtro_Pagertel') and LEN(TRIM(Form.Filtro_Pagertel))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pagertel=" & Form.Filtro_Pagertel>
			</cfif>
			<cfif isdefined('Form.Filtro_Pagernum') and LEN(TRIM(Form.Filtro_Pagernum))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pagernum=" & Form.Filtro_Pagernum>
			</cfif>
			<cfif isdefined('Form.Filtro_Pfax') and LEN(TRIM(Form.Filtro_Pfax))>
			<cfset regresar = regresar & Iif(Len(Trim(regresar)) NEQ 0, DE("&"), DE("")) & "Filtro_Pfax=" & Form.Filtro_Pfax>
			</cfif>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="titulolistas">
						<form name="formBuscar" method="post" action="rh.cfm">	
							<table width="100%" border="0" cellpadding="0" cellspacing="1">
								<tr> 
									<td colspan="5" valign="middle" align="right">  
										<label id="letiqueta1"><a href="<cfoutput>#regresar#</cfoutput>">Seleccione una persona:  </a></label>
										<a href="listaRH.cfm">
											<img src="/cfmx/sif/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"> 
										</a>
									</td>
								</tr>
							</table>
						</form>	
					</td>
				</tr>
				<tr>
				  <td>
						<cfinclude template="formRh.cfm">
					</td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
<script language="JavaScript" type="text/javascript">
	function validaPersona(k,liga){
		var LvarPesona = document.formHeader.persona.value;
		alert(k + ' k');
		alert(document.formHeader.persona.value + ' Persona');
		alert(liga+ ' Liga');
		if(k==2){
			if(LvarPesona != ''){
				location.href=liga + "&persona=" + LvarPesona;		
			}else{
				location.href=liga;
			}
		}else{
			if(LvarPesona != ''){
				location.href=liga + "&persona=" + LvarPesona;
			}else{
				alert('Error, primeramente debe seleccionar a una persona para acceder esta opción');
			}
		}
	}
</script>

<script type="text/javascript">
<!--
	/*function tab_set_current (n){
		validaPersona(escape(n),'expediente-cons.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
	}*/
	function funcPersona (n){
		validaPersona(escape(n),'rh.cfm?o='+escape(n)+'&sel=1');
	}
//-->
</script>	

