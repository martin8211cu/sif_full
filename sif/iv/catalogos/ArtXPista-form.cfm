<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL --->
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

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">


<cfif isdefined("url.Pista_id") and not isdefined("form.Pista_id")>
	<cfset form.Pista_id = url.Pista_id >
</cfif>

<cfif isdefined("url.Aid") and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid >
</cfif>

<cfif isdefined("url.fAcodigo") and not isdefined("form.fAcodigo")>
	<cfset form.fAcodigo = url.fAcodigo >
</cfif>
<cfif isdefined("url.fADescripcion") and not isdefined("form.fADescripcion")>
	<cfset form.fADescripcion = url.fADescripcion >
</cfif>
<cfif isdefined("url.Aid") and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid >
</cfif>

<cfset modo='ALTA'>
<cfset navegacion ="">
<cfif isdefined("form.Pista_id") and len(trim(form.Pista_id))>
	<cfset modo = 'CAMBIO'> 
	<cfset navegacion = "Pista_id=#form.Pista_id#" >
</cfif>
<cfif isdefined("form.Aid") and len(trim(form.Aid))>
	<cfset navegacion = navegacion & "&Aid=#form.Aid#" >
</cfif>
<cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo))>
	<cfset navegacion =  navegacion & "&fAcodigo=#form.fAcodigo#" >
</cfif>
<cfif isdefined("form.fADescripcion") and len(trim(form.fADescripcion))>
	<cfset navegacion = navegacion & "&fADescripcion=#form.fADescripcion#" >
</cfif>

<cfquery datasource="#session.dsn#" name="rsPistas">
	select Pista_id, Ecodigo, Ocodigo, Codigo_pista, Descripcion_pista, Pestado, BMUsucodigo, ts_rversion
	from Pistas
	where Ecodigo =  #session.Ecodigo# 
  	  and Pestado = 1
	order by Codigo_pista
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery name = "rsdata" datasource="#session.DSN#">
		select Pista_id, Ecodigo, Ocodigo, Codigo_pista, Descripcion_pista, Pestado, BMUsucodigo, ts_rversion
		from   Pistas
		where  Pista_id = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#form.Pista_id#">
			and Ecodigo =  #session.Ecodigo# 
	</cfquery>
</cfif>
<form name="filtro" method="post" action="ArtXPista-SQL.cfm">
 <input name="Pagina" type="hidden" tabindex="-1" value="<cfoutput>#form.Pagina#</cfoutput>">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr> 
    	<td colspan="2"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td>
    </tr>
	<tr>
		<td colspan="2" >
				<table width="100%" border="0">
					<tr>
                      <td valign="top">&nbsp;</td>
                      <td valign="top" nowrap><div align="right"><strong>C&oacute;digo de Pista:</strong></div></td>
                      <td valign="top" nowrap>
                        <div align="left">
                       	  <cfif isdefined("form.Pista_id") and len(trim(form.Pista_id)) neq 0>
                            	<cf_sifpistas tabindex="1" id='#form.Pista_id#' form = 'filtro'>
                            	<cfelse>                           	
                            	<cf_sifpistas tabindex="1" form = 'filtro'>
                          </cfif>
                      </div></td>
                      <td valign="top" nowrap><div align="right"><strong>Almac&eacute;n:</strong></div></td>
						<td valign="top" nowrap>
							<cfif isdefined("form.Aid") and len(trim(form.Aid)) neq 0>
								<cf_sifalmacen tabindex="1" id='#form.Aid#' form = 'filtro'>
							<cfelse>
								<cf_sifalmacen tabindex="1" form = 'filtro'>
							</cfif>
					  </td>
                      <td nowrap>
					  	<input tabindex="1" type="submit" value="Filtrar" name="btnFiltrar" >
 					  	<input tabindex="1" type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
						
						</td>
				  </tr>
				  <cfoutput>
					<tr>
					  <td width="15%" valign="top">&nbsp;
					  	 
				      </td>
					  <td nowrap><div align="right"><strong>C&oacute;digo de Art&iacute;culo </strong></div></td>
					  <td>
                        <input tabindex="1" name="fAcodigo" type="text" size="15" maxlength="15" value="<cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo)) neq 0>#form.fAcodigo#</cfif>" onFocus="javascript: this.select();">
                        
                      </td>
					  <td><strong>Descripci&oacute;n</strong></td>
					  <td>
                        <input tabindex="1" name="fADescripcion" type="text" size="40" maxlength="80" value="<cfif isdefined("form.fADescripcion") and len(trim(form.fADescripcion)) neq 0>#form.fADescripcion#</cfif>" onFocus="javascript: this.select();">
                      </td>
					  <td width="16%">&nbsp;</td>
				  </tr>
					<tr>
						<td colspan="6" align="center">
						<cfif modo NEQ "ALTA">
							<cfset ts = "">
							<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
							</cfinvoke>
							<input type="hidden" name = "ts_rversion" value ="#ts#">
						</cfif>
						</td>	
					</tr>
				</cfoutput>
				</table>
		</td>
	</tr>
	</table>
	</form>
	<cfif isdefined("form.Aid")  and isdefined("form.Pista_id") >
		<form name="form1" method="post" action="ArtXPista-SQL.cfm">
				<input type="hidden" name="Aid" value="<cfoutput>#Form.Aid#</cfoutput>">
				<table width="100%" border="0">
					<tr>
						<td nowrap><input tabindex="1" type="checkbox" name="chkTodos" value="T" onClick="javascript:Marcar(this);"></td>
						<td nowrap><strong>Marcar Todos.</strong>
						<input type="hidden" name="Pista_id" id="Pista_id" value="<cfoutput>#form.Pista_id#</cfoutput>">
						<input type="hidden" name="borrados" id="borrados" value="">
						</td>
					</tr>
				</table>
				<cfset navegacion = ''>
				<cfoutput>
					<cfset paramExtra = ',#form.pagina# as pagina'>	
				</cfoutput>	
				<cfif isdefined("form.Pista_id") and len(trim(form.Pista_id)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pista_id=" & Form.Pista_id>
				</cfif>
				 <cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo)) NEQ 0>
				 	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fAcodigo=" & Form.fAcodigo>
					<cfset paramExtra = paramExtra & ",'' as fAcodigo">
				 </cfif>
				 <cfif isdefined("form.fADescripcion") and len(trim(form.fADescripcion)) NEQ 0>
				 	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fADescripcion=" & Form.fADescripcion>
					<cfset paramExtra = paramExtra & ",'' as fADescripcion">
				 </cfif>
				 <cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
				 	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Aid=" & Form.Aid>
				 </cfif>
                 	<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery datasource="#session.dsn#" name="rsArtxpista">
						select  a.Ecodigo, art.Aid, a.Pista_id, a.Alm_Aid, a.BMUsucodigo,
						  p.Codigo_pista #_Cat# '-' #_Cat# p.Descripcion_pista as NombPista,  
						  al.Almcodigo #_Cat# '-' #_Cat# al.Bdescripcion as NombAlmacen,
						  art.Acodigo, art.Adescripcion, art.Ucodigo,
						  art.Ucodigo #_Cat# '-' #_Cat# u.Udescripcion as Udesc, 
						  case a.Estado 
						  	when 1 	then 
								<cf_dbfunction name="to_char" args="a.Aid"> #_Cat#'|'#_Cat#coalesce(<cf_dbfunction name="to_char" args="#form.Aid#"> #_Cat#'|'#_Cat#'#form.Pista_id#','') 
										
									else '' end as checked,
						  ex.Alm_Aid as IDalmacen, '#form.Pista_id#' as pista, art.Aid as IDart #paramExtra#
						from Articulos art
							  inner join Existencias ex
								on art.Aid = ex.Aid
								and art.Ecodigo = ex.Ecodigo
							  left  outer join  Artxpista a
							    on  a.Ecodigo = ex.Ecodigo 
								and a.Aid = ex.Aid
								and a.Alm_Aid = ex.Alm_Aid
								<cfif isdefined("form.Pista_id") and len(trim(form.Pista_id)) NEQ 0>
									and a.Pista_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pista_id#">
								</cfif>
							  left outer join Pistas p
								on  p.Ecodigo =  a.Ecodigo
								and p.Pista_id = a.Pista_id
	
							   inner join Almacen al
								on  al.Ecodigo = ex.Ecodigo
								and al.Aid = ex.Alm_Aid
	
							  inner join Unidades u
								on  u.Ecodigo = art.Ecodigo
								and u.Ucodigo = art.Ucodigo
							where art.Ecodigo =  #session.Ecodigo# 
								and ex.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
							   <cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo)) NEQ 0>
									and upper(art.Acodigo) like '%#Ucase(form.fAcodigo)#%'
							   </cfif>
							   <cfif isdefined("form.fADescripcion") and len(trim(form.fADescripcion)) NEQ 0>
									and upper(art.Adescripcion) like '%#Ucase(form.fADescripcion)#%'
							   </cfif>
							order by art.Aid
					</cfquery>
							
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
						<cfinvokeargument name="query"    			value="#rsArtxpista#"/>
						<cfinvokeargument name="desplegar" 			value="Acodigo, Adescripcion, Udesc"/>
						<cfinvokeargument name="etiquetas" 			value="Código, Descripción, Unidad de Medida"/>
						<cfinvokeargument name="formatos" 			value=""/>
						<cfinvokeargument name="align" 				value="left, left,left"/>
						<cfinvokeargument name="ajustar" 			value="N,N,N"/>
						<cfinvokeargument name="irA" 				value="ArtXPista-SQL.cfm"/>
						<cfinvokeargument name="checkboxes" 		value="S"/>
						<cfinvokeargument name="checkedcol" 		value="checked"/>
						<cfinvokeargument name="checkbox_function" 	value="aborrar(this)"/>	
						<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						<cfinvokeargument name="botones" 			value="Asociar,Regresar"/>
						<cfinvokeargument name="formname" 			value="form1"/>
						<cfinvokeargument name="incluyeform" 		value="false"/>
						<cfinvokeargument name="keys" 				value="IDart, IDalmacen, pista"/>
						<cfinvokeargument name="showLink" 			value="false"/>  
						<cfinvokeargument name="maxrows" 			value="15"/>
						<cfinvokeargument name="Debug" 				value="N"/>
						<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
				  </cfinvoke>
				
				</form>
				
				<script language="JavaScript" type="text/javascript">
					function funcRegresar() {
						location.href='/cfmx/sif/iv/catalogos/ArtXPista.cfm';
						return false;
					}
					function funcAsociar() {
						<cfif isdefined('form.fAcodigo') and form.fAcodigo NEQ ''>
							document.form1.FACODIGO.value ='<cfoutput>#form.fAcodigo#</cfoutput>';
						</cfif>
						<cfif isdefined('form.fADescripcion') and form.fADescripcion NEQ ''>
							document.form1.FADESCRIPCION.value ='<cfoutput>#form.fADescripcion#</cfoutput>';
						</cfif>						
						<cfif isdefined('form.Pagina') and form.Pagina NEQ ''>
							document.form1.PAGINA.value ='<cfoutput>#form.pagina#</cfoutput>';
						</cfif>												
						return true;
					}				
					function aborrar(obj){
						if ( !obj.checked ){
							if ( document.form1.borrados.value.length > 0 ){
								document.form1.borrados.value = document.form1.borrados.value + ',' + obj.value;
							}
							else{
								document.form1.borrados.value =  obj.value;
							}
						}
					
					}
					
					function Marcar(c) {
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
					}
				</script>
	</cfif>
 
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtro");
	
	objForm.Pista_id.required = true;
	objForm.Pista_id.description="Código de la Pista";

	objForm.Aid.required = true;
	objForm.Aid.description="Almacén";
	
	function deshabilitarValidacion(){
		objForm.Aid.required = false;
		objForm.Pista_id.required = false;
	}
	function limpiar(){
		document.filtro.fAcodigo.value = '';
		document.filtro.fADescripcion.value = '';
		document.filtro.Almcodigo.value = '';								
		document.filtro.Bdescripcion.value = '';										
		document.filtro.Aid.value = '';		
		document.filtro.Codigo_pista.value = '';		
		document.filtro.Descripcion_pista.value = '';				
		document.filtro.Pista_id.value = '';							
	}					
	
	document.filtro.Codigo_pista.focus();
</script> 	