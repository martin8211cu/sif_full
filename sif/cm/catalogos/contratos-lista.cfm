<cfparam name="aprobado" default=false>

<script language="JavaScript1.2" type="text/javascript">
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function funcNuevo(){
		document.lista.action = 'contratos.cfm';
		document.lista.submit();
	}
</script>

<!---Carga de valores recibidos por URL---->
<cfif isdefined("url.SNnumeroFiltro") and not isdefined("form.SNnumeroFiltro")>
	<cfset form.SNnumeroFiltro = url.SNnumeroFiltro>
</cfif>
<cfif isdefined("url.SNnombreFiltro") and not isdefined("form.SNnombreFiltro")>
	<cfset form.SNnombreFiltro= url.SNnombreFiltro >
</cfif>
<cfif isdefined("url.ECdescFiltro") and not isdefined("form.ECdescFiltro")>
	<cfset form.ECdescFiltro= url.ECdescFiltro >
</cfif>
<cfif isdefined("url.ECfechainiFiltro") and not isdefined("form.ECfechainiFiltro")>
	<cfset form.ECfechainiFiltro= url.ECfechainiFiltro >
</cfif>
<cfif isdefined("url.ECfechafinFiltro") and not isdefined("form.ECfechafinFiltro")>
	<cfset form.ECfechafinFiltro= url.ECfechafinFiltro >
</cfif>
<cfif isdefined("url.ConsecutivoFiltro") and not isdefined("form.ConsecutivoFiltro")>
	<cfset form.ConsecutivoFiltro = url.ConsecutivoFiltro>
</cfif>
<cfif isdefined("url.SNcodigoi") and not isdefined("form.SNcodigoi")>
	<cfset form.SNcodigoi= url.SNcodigoi >
</cfif>

<!----Carga de valores de navegacion----->
<cfset navegacion ="">
<cfif isdefined("Form.ECdescFiltro") and Len(Trim(Form.ECdescFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ECdescFiltro=" & Form.ECdescFiltro>
</cfif>
<cfif isdefined("Form.ECfechainiFiltro") and Len(Trim(Form.ECfechainiFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ECfechainiFiltro=" & Form.ECfechainiFiltro>
</cfif>
<cfif isdefined("Form.ECfechafinFiltro") and Len(Trim(Form.ECfechafinFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ECfechafinFiltro=" & Form.ECfechafinFiltro>
</cfif>
<cfif isdefined("Form.SNcodigoi") and Len(Trim(Form.SNcodigoi)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigoi=" & Form.SNcodigoi>
</cfif>
<cfif isdefined("form.ConsecutivoFiltro") and Len(Trim(form.ConsecutivoFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ConsecutivoFiltro=" & Form.ConsecutivoFiltro>
</cfif>
<cfif isdefined("form.ECfechainiFiltro") and len(trim(form.ECfechainiFiltro))>
	<cfset vfechadesdeF = LSDateFormat(form.ECfechainiFiltro,'dd/mm/yyyy')>
<cfelse>
	<cfset vfechadesdeF = ''>
</cfif>
<cfif isdefined("form.ECfechafinFiltro") and len(trim(form.ECfechafinFiltro))>
	<cfset vfechahastaF = LSDateFormat(form.ECfechafinFiltro,'dd/mm/yyyy')>
<cfelse>
	<cfset vfechahastaF = ''>
</cfif>

<cfquery name="rsLista" datasource="#session.DSN#">
	select 	a.Consecutivo, a.ECid, a.SNcodigo, b.SNnumero, b.SNnombre as proveedor, a.ECdesc, a.ECfechaini, a.ECfechafin
	from EContratosCM a
		inner join SNegocios b
			on a.SNcodigo=b.SNcodigo
				and a.Ecodigo=b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
     <cfif isdefined("form.ConsecutivoFiltro") and len(trim(form.ConsecutivoFiltro)) GT 0>
		and a.Consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ConsecutivoFiltro#">
	</cfif>
	<cfif isdefined("form.SNnumeroFiltro") and len(trim(form.SNnumeroFiltro)) GT 0>
		and upper(b.SNnumero) like '%#Ucase(form.SNnumeroFiltro)#%'
	</cfif>
	<cfif isdefined("form.SNnombreFiltro") and len(trim(form.SNnombreFiltro)) GT 0>
		and upper(b.SNnombre) like '%#Ucase(form.SNnombreFiltro)#%'
	</cfif>
	<cfif isdefined("form.ECdescFiltro") and len(trim(form.ECdescFiltro)) GT 0>
		and upper(a.ECdesc) like '%#Ucase(form.ECdescFiltro)#%'
	</cfif>
	<cfif isdefined("form.ECfechainiFiltro") and len(trim(form.ECfechainiFiltro)) GT 0>
		and ECfechaini >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECfechainiFiltro)#">
	</cfif>
	<cfif isdefined("form.ECfechafinFiltro") and len(trim(form.ECfechafinFiltro)) GT 0>
		and ECfechafin <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECfechafinFiltro)#">
	</cfif>
	<cfif aprobado EQ true>
		and ECestado = 2
	<cfelse>
		and ECestado = 0
	</cfif>
	order by Consecutivo
</cfquery>

<cf_templateheader title="Catálogo de contratos ">
	<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Contratos'>
			<form name="form1" method="get" action="">
				<cfoutput>
					  <table width="100%" border="0" class="areaFiltro">
						<tr>
						  <td width="1%" nowrap align="right"><strong>Proveedor:</strong></td>
						  <td width="16%">
							<cfif isdefined("form.SNcodigoi") and len(trim(form.SNcodigoi))>
								<cf_sifsociosnegocios2  sntiposocio="P" tabindex="1" sncodigo="SNcodigoi" snnumero="SNnumeroFiltro" snnombre="SNnombreFiltro" frame="frame1" idquery="#form.SNcodigoi#">
							<cfelse>
								<cf_sifsociosnegocios2  sntiposocio="P" tabindex="1" sncodigo="SNcodigoi" snnumero="SNnumeroFiltro" snnombre="SNnombreFiltro" frame="frame1">
							</cfif>
						  </td>
						  <td width="9%" align="right"><strong>No. Contrato:</strong></td>
						  <td width="9%" align="right"><input name="ConsecutivoFiltro" onFocus="this.select()" type="text" id="ConsecutivoFiltro" value="<cfif isdefined('form.ConsecutivoFiltro') and form.ConsecutivoFiltro NEQ ''>#form.ConsecutivoFiltro#</cfif>"></td>
						  <td width="9%" align="right"><strong>Contrato:</strong></td>
						  <td width="17%"><input name="ECdescFiltro" onFocus="this.select()" type="text" id="ECdescFiltro" value="<cfif isdefined('form.ECdescFiltro') and form.ECdescFiltro NEQ ''>#form.ECdescFiltro#</cfif>"></td>
						  <td width="27%" colspan="2" rowspan="2"><div align="center">
							<input type="submit" name="Submit" value="Filtrar">
							</div></td>
						</tr>
						<tr>
						  <td width="1%" nowrap align="right"><strong>Fecha Inicio:</strong></td>
						  <td width="16%">
							 <cf_sifcalendario  tabindex="1" form="form1" name="ECfechainiFiltro" value="#vfechadesdeF#">
						  </td>
						  <td width="9%" align="right" nowrap>&nbsp;</td>
						  <td width="9%" align="right" nowrap>&nbsp;</td>
						  <td width="9%" align="right" nowrap><strong>Fecha Vencimiento:</strong></td>
						  <td width="17%">
							<cf_sifcalendario  tabindex="1" form="form1" name="ECfechafinFiltro" value="#vfechahastaF#">
						  </td>
						  </tr>
					  </table>
			  	</cfoutput>
            </form>
			 			<table width="100%" border="0">
                        	<tr>
                             	<td colspan="2">
									<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
											<cfinvokeargument name="query" 				value="#rsLista#"/>
											<cfinvokeargument name="desplegar" 			value="Consecutivo, SNnumero,proveedor,ECdesc,ECfechaini,ECfechafin"/>
											<cfinvokeargument name="etiquetas" 			value="No. Contrato, Código, Proveedor, Contrato, Fecha de Inicio, Fecha de Vencimiento"/>
											<cfinvokeargument name="formatos" 			value="S, S, S, S, D, D"/>
											<cfinvokeargument name="align" 				value="left, left, left, left, left, left"/>
											<cfinvokeargument name="ajustar" 			value="N"/>
											<cfinvokeargument name="checkboxes" 		value="N"/>
											<cfinvokeargument name="Nuevo" 				value="contratos.cfm"/>
											<cfinvokeargument name="irA" 				value="contratos.cfm?&aprobado=#aprobado#"/>
											<cfinvokeargument name="botones" 			value="Nuevo"/>
											<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
											<cfinvokeargument name="keys" 				value="ECid"/>
											<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
									</cfinvoke>
                            	</td>
                            </tr>
                        </table>
	  <cf_web_portlet_end>
<cf_templatefooter>