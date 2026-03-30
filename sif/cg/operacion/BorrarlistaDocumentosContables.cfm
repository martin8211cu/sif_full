
	<cf_templateheader title="	Documentos Contables">
		<link type="text/css" rel="stylesheet" href="../../css/asp.css">
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">        <cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista 
            de Documentos Contables'>
	
<cfparam name="PageNum_rsDocumentos" default="1">
<cfquery name="rsLotes" datasource="#Session.DSN#">
	select Cconcepto, Cdescripcion 
	from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsDocumentos" datasource="#Session.DSN#">
	select 
		a.IDcontable, 
		a.Ecodigo, 
		a.Cconcepto, 
		b.Cdescripcion,
		a.Eperiodo, 
		a.Emes, 
		a.Edocumento, 
		a.Efecha, 
		a.Edescripcion, 
		a.Edocbase, 
		a.Ereferencia, 
		a.ECauxiliar, 
		a.ECusuario, 
		a.ECselect, 
		a.ts_rversion
	from EContables a	
	inner join ConceptoContableE b
			on a.Ecodigo = b.Ecodigo
	  	and a.Cconcepto = b.Cconcepto
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  <cfif isdefined("Form.Filtrar")>
			<cfif isdefined("Form.lote") and Form.lote NEQ -1>
				and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.lote#">
			</cfif>
			<cfif isdefined("Form.poliza") and Trim(Len(Form.poliza)) GT 0>
				and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.poliza#">
			</cfif>
			<cfif isdefined("Form.descripcion") and len(trim(Form.descripcion)) GT 0>
				and upper(a.Edescripcion) like '%#Ucase(Form.descripcion)#%'
			</cfif>
			<cfif isdefined("Form.fecha") and len(trim(Form.fecha)) GT 0 and LSisdate(Form.fecha)>
				and a.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#Form.fecha#">
			</cfif>
			<cfif isdefined("Form.periodo") and Form.periodo NEQ -1>
				and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.periodo#">
			</cfif>
			<cfif isdefined("Form.mes") and Form.mes neq -1>
				and a.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">
			</cfif>
	  </cfif>
	order by Efecha desc, 
		a.Cconcepto, 
		a.Edocumento, 
		a.Eperiodo, 
		a.Emes
</cfquery>
<cfquery name="rsDocumentos2" datasource="#Session.DSN#">
		select distinct
			a.IDcontable,
			b.Mnombre,
			b.Msimbolo, 
			c.Odescripcion, 
			sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
			sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos
		from DContables a, Monedas b, Oficinas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Ecodigo = c.Ecodigo
		  and a.Ocodigo = c.Ocodigo
		  and a.Mcodigo = b.Mcodigo
		group by a.IDcontable, b.Mnombre, b.Msimbolo, c.Odescripcion
</cfquery>
<cfquery name="rsDesbal" dbtype="query">
	select IDcontable
	from rsDocumentos2 
	where Debitos-Creditos != 0.00
</cfquery>
<cfquery name="rsPer" dbtype="query">
	select distinct Eperiodo
	from rsDocumentos
</cfquery>
<cfquery name="rsMeses" datasource="sifControl">
	select b.VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by b.VSvalor
</cfquery>
<cfif isDefined("Form.Aplicar") and isdefined("Form.chk")>
		<cfloop index="IDcontable" list="#Form.chk#">
				<cfinvoke 
				 component="sif.Componentes.CG_AplicaAsiento"
				 method="CG_AplicaAsiento">
				 <cfinvokeargument name="IDcontable" value="#IDcontable#">
				</cfinvoke>
		</cfloop>
		<cflocation addtoken="no" url="listaDocumentosContables.cfm">
</cfif>
<cfset MaxRows_rsDocumentos=17>
<cfset StartRow_rsDocumentos=Min((PageNum_rsDocumentos-1)*MaxRows_rsDocumentos+1,Max(rsDocumentos.RecordCount,1))>
<cfset EndRow_rsDocumentos=Min(StartRow_rsDocumentos+MaxRows_rsDocumentos-1,rsDocumentos.RecordCount)>
<cfset TotalPages_rsDocumentos=Ceiling(rsDocumentos.RecordCount/MaxRows_rsDocumentos)>
<cfset QueryString_rsDocumentos=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsDocumentos,"PageNum_rsDocumentos=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsDocumentos=ListDeleteAt(QueryString_rsDocumentos,tempPos,"&")>
</cfif>
	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
	<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
	<cfset PolizaNum = t.Translate('PolizaNum','La p&oacute;liza debe ser num&eacute;rica.')>
	
		    <cfform action="listaDocumentosContables.cfm" method="post" name="form1">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr> 
							<td colspan="10"><cfinclude template="../../portlets/pNavegacionCG.cfm"></td>
						</tr>
						<tr>
							<td colspan="9">
								<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
									<tr> 
										<td>&nbsp;</td>
										<td nowrap ><b>Lote</b></td>
										<td width="2%" ><b><cfoutput>#PolizaE#</cfoutput></b></td>
										<td width="35%" nowrap ><b>Descripci&oacute;n</b></td>
										<td nowrap ><b>Per&iacute;odo</b></td>
										<td nowrap ><b>Mes</b></td>
										<td width="12%" nowrap ><b>Fecha</b></td>
										<td width="8%" >&nbsp;</td>
										<td width="13%" >&nbsp;</td>
									</tr>
									<tr> 
										<td>&nbsp;</td>
										<td width="15%" nowrap class="subTitulo"> <select name="lote">
											<option value="-1">Todos</option>
											<cfoutput query="rsLotes"> 
											<option value="#Cconcepto#">#Cdescripcion#</option>
											</cfoutput> </select></td>
										<td width="2%" class="subTitulo"> 
										<cfinput type="text" name="poliza" message="#PolizaNum#" maxlength="5" size="5" validate="integer"></td>
										<td nowrap class="subTitulo"> <input name="descripcion" type="text" size="50" maxlength="100" value=""> 
										</td>
										<td nowrap class="subTitulo"><select name="periodo">
										<option value="-1">Todos</option>
										<cfoutput query="rsPer">
										<option value="#Eperiodo#">#Eperiodo#</option>
										</cfoutput>
										</select></td>
										<td nowrap class="subTitulo"><select name="mes">
										<option value="-1">Todos</option>				  
											<cfoutput query="rsMeses">
												<option value="#VSvalor#">#VSdesc#</option>
											</cfoutput>	
										</select></td>
										<td nowrap class="subTitulo"> 
										<cf_sifcalendario name="fecha">
										</td>
										<td class="subTitulo">&nbsp;</td>
										<td class="subTitulo"><input type="submit" name="Filtrar" value="Filtrar"></td>
									</tr>
								</table>	
							</td>		
						</tr>
						<tr> 
							<td width="1%"><input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);"></td>
							<td colspan="2" ><b>Seleccionar Todos </b>
								<input name="IDcontable" type="hidden" value=""> </td>
							<td colspan="6" >&nbsp;</td>
						</tr>
						<tr> 
							<td class="tituloListas" ></td>
							<td  class="tituloListas">Lote</td>
							<td width="2%"  class="tituloListas"><cfoutput>#PolizaE#</cfoutput></td>
							<td class="tituloListas">Descripci&oacute;n </td>
							<td class="tituloListas">Fecha</td>
							<td width="1%" nowrap  class="tituloListas">Per&iacute;odo</td>
							<td width="1%" nowrap  class="tituloListas">Mes</td>
							<td colspan="2" nowrap class="tituloListas">&nbsp;</td>
						</tr
						>
						<cfset cuantosReg = 0 >
						<cfoutput query="rsDocumentos" startrow="#StartRow_rsDocumentos#" maxrows="#MaxRows_rsDocumentos#"> 
							<cfset Desbalanceada = false>
							<cfset IDC = rsDocumentos.IDcontable>
							<cfloop query="rsDesbal">
								<cfif (IDC EQ rsDesbal.IDcontable)>
									<cfset Desbalanceada = true>
									<cfbreak>
								</cfif>
							</cfloop>
							<tr <cfif rsDocumentos.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
								<td><input type='checkbox' name='chk'  value='#rsDocumentos.IDcontable#' onClick='javascript:document.form1.chkTodos.checked=false;' <cfif desbalanceada>disabled</cfif>></td>
								<td nowrap onClick="javascript:Editar('#rsDocumentos.IDcontable#');" >&nbsp;<a href="javascript:Editar('#rsDocumentos.IDcontable#');">#rsDocumentos.Cdescripcion#</a></td>
								<td width="2%" onClick="javascript:Editar('#rsDocumentos.IDcontable#');" > 
									<div align="left">&nbsp;<a href="javascript:Editar('#rsDocumentos.IDcontable#');">#rsDocumentos.Edocumento#</a></div></td>
								<td nowrap onClick="javascript:Editar('#rsDocumentos.IDcontable#');" ><a href="javascript:Editar('#rsDocumentos.IDcontable#');" title="#rsDocumentos.Edescripcion#"> 
									<cfif len(rsDocumentos.Edescripcion) LTE 50>
										#rsDocumentos.Edescripcion# 
										<cfelse>
										#Mid(rsDocumentos.Edescripcion,1,50)#... 
									</cfif>
									</a></td>
								<td onClick="javascript:Editar('#rsDocumentos.IDcontable#');" ><a href="javascript:Editar('#rsDocumentos.IDcontable#');">#LSDateFormat(rsDocumentos.Efecha,'dd/mm/yyyy')#</a></td>
								<td nowrap onClick="javascript:Editar('#rsDocumentos.IDcontable#');" ><a href="javascript:Editar('#rsDocumentos.IDcontable#');">#rsDocumentos.Eperiodo#</a></td>
								<td nowrap onClick="javascript:Editar('#rsDocumentos.IDcontable#');" ><a href="javascript:Editar('#rsDocumentos.IDcontable#');">#rsDocumentos.Emes#</a></td>
								<td colspan="2" nowrap onClick="javascript:Editar('#rsDocumentos.IDcontable#');" > <cfif Desbalanceada>
										<font color="##FF0000">No balanceada!</font> 
										<cfelse>
										&nbsp;</cfif></td>
							</tr>
							<cfset cuantosReg = cuantosReg + 1 >
							</cfoutput> 
							<tr> 
								<td>&nbsp;</td>
								<td colspan="8"><table border="0" width="50%" align="center">
										<cfoutput> 
											<tr> 
												<td width="23%" align="center"> <cfif PageNum_rsDocumentos GT 1>
														<a href="#CurrentPage#?PageNum_rsDocumentos=1#QueryString_rsDocumentos#"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> 
													</cfif> </td>
												<td width="31%" align="center"> <cfif PageNum_rsDocumentos GT 1>
														<a href="#CurrentPage#?PageNum_rsDocumentos=#Max(DecrementValue(PageNum_rsDocumentos),1)##QueryString_rsDocumentos#"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> 
													</cfif> </td>
												<td width="23%" align="center"> <cfif PageNum_rsDocumentos LT TotalPages_rsDocumentos>
														<a href="#CurrentPage#?PageNum_rsDocumentos=#Min(IncrementValue(PageNum_rsDocumentos),TotalPages_rsDocumentos)##QueryString_rsDocumentos#"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> 
													</cfif> </td>
												<td width="23%" align="center"> <cfif PageNum_rsDocumentos LT TotalPages_rsDocumentos>
														<a href="#CurrentPage#?PageNum_rsDocumentos=#TotalPages_rsDocumentos##QueryString_rsDocumentos#"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> 
													</cfif> </td>
											</tr>
										</cfoutput> </table></td>
							</tr>
						</table>
						<div align="center">
							<input name="NuevoE" type="submit" value="Nuevo" onClick= "javascript:document.form1.action='DocumentosContables.cfm';">
							<input name="Aplicar" type="submit" value="Aplicar" onClick= "javascript:return valida();">
						</div>
					</cfform>
<script language="JavaScript1.2">
	function valida() {
		if (validaChecks()) 
			return confirm('¿Desea aplicar los documentos seleccionados?');	
		return false;
	}

	function validaChecks() {
		document.form1.action='listaDocumentosContables.cfm';		
		<cfif cuantosReg NEQ 0> 
			<cfif cuantosReg EQ 1>
				if (document.form1.chk.checked)					
					return true;
				else
					alert("Debe seleccionar al menos un documento para aplicar");									
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) bandera = true;						
				}
				if (bandera)
					return true;
				else
					alert("Debe seleccionar al menos un documento para aplicar");											
			</cfif>	 			
		<cfelse>
			alert("¡No existen documentos por aplicar!");							
		</cfif>
		return false;
	}

	function Marcar(c) {

		<cfif cuantosReg GT 0>
		if (c.checked) {
			for (counter = 0; counter < document.form1.chk.length; counter++)
			{
				if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
					{  document.form1.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form1.chk.disabled)) {
				document.form1.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form1.chk.length; counter++)
			{
				if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
					{  document.form1.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.form1.chk.disabled)) {
				document.form1.chk.checked = false;
			}
		};
		</cfif>
	}

	function Editar(data) {
		if (data!="") {
			document.form1.action='DocumentosContables.cfm';
			document.form1.IDcontable.value = data;
			document.form1.submit();
		}
		return false;
	}
</script>			
            	
		<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>