<cfsetting requesttimeout="43200">

<cfparam name="sufix" default="">

<cfif not isdefined("url.inter")  and not isdefined("form.inter")>
 	<cfset inter = 'N'>
</cfif>
<cfif isdefined("url.inter") and not isdefined("form.inter")>
 	<cfset inter = url.inter>
</cfif>
<cfif not isdefined("url.inter") and  isdefined("form.inter")>
 	<cfset inter = form.inter>
</cfif>


<cfif isdefined("url.paramretro") and not isdefined("form.paramretro")>
 	<cfset paramretro = url.paramretro>
</cfif>
<cfif not isdefined("url.paramretro") and  isdefined("form.paramretro")>
 	<cfset paramretro = form.paramretro>
</cfif>

<cfset Lvartitle ="Lista de Documentos Contables">
<cfif isdefined("paramretro")>
	<cfset Lvartitle ="Lista de Documentos Contables Retroactivos">
</cfif>

<cf_templateheader title="#LvarTitle#">

<!---
	FILTRO DE DOCUMENTOS CONTABLES
--->
	<cfquery name="rsLotes" datasource="#Session.DSN#">
		select  a.Cconcepto, Cdescripcion
		from ConceptoContableE a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and not exists ( 
			select 1 from UsuarioConceptoContableE b 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Cconcepto = b.Cconcepto
			and a.Ecodigo = b.Ecodigo
		)  
		UNION
		select a.Cconcepto, Cdescripcion 
		from ConceptoContableE a,UsuarioConceptoContableE b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.Cconcepto = b.Cconcepto
		and a.Ecodigo = b.Ecodigo
		and b.Usucodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
	</cfquery>
	<cfquery name="rsPer" datasource="#Session.DSN#">
		select distinct Eperiodo
		from EContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>
	<cfset defaults = "lote,poliza,descripcion,periodo,mes,fecha,fechaGen">
	<cfset navegar = "">
	<cfloop list="#defaults#" index="item">
		<cfif isdefined("url."&item) and not isdefined("form."&item)><cfset valor = evaluate("url."&item)><cfelseif isdefined("form."&item) and not isdefined("form.bLimpiar")><cfset valor = evaluate("form."&item)><cfelse><cfset valor = ""></cfif>
		<cfparam name="L#item#" default="#HTMLEditFormat(valor)#">
		<cfset navegar = navegar & iif(len(trim(navegar)),DE("&"),DE("")) & "#item#=" & valor>
	</cfloop>
	<cfif not isdefined("form.ECusuario")>
		<!---
		<cfset form.Usucodigo = session.Usucodigo>
		--->
		<cfset form.ECusuario = "">
	</cfif>
	<cfif isdefined("url.ver") and not isdefined("form.ver")>
		<cfset form.ver = url.ver>
	</cfif>
	<cfif isdefined("url.origen") and not isdefined("form.origen")>
		<cfset form.origen = url.origen>
	</cfif>
	<cfif not isdefined("form.ver")>
		<cfset form.ver = 15>
	</cfif>

<!---
	LISTA DE DOCUMENTOS CONTABLES
--->

	<cfquery name="rsLista" datasource="#session.DSN#">
		select  a.IDcontable, 
				b.Cdescripcion,
				a.Eperiodo, 
				a.Emes, 
				a.Edocumento, 
				a.Efecha, 
				a.Oorigen,
				a.ECfechacreacion, 
				a.Edescripcion,
				(select	case when sum(case when c.Dmovimiento = 'D' then c.Dlocal else 0 end) != sum(case when c.Dmovimiento = 'C' then c.Dlocal else 0 end) then '<font color="##FF0000">Desbalanceada!</font>' else '' end
				 from DContables c
				 where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  				 and c.IDcontable = a.IDcontable) as balanceada,
				(select	case when sum(case when c.Dmovimiento = 'D' then c.Dlocal else 0 end) != sum(case when c.Dmovimiento = 'C' then c.Dlocal else 0 end) then a.IDcontable else -1 end
				 from DContables c
				 where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  				 and c.IDcontable = a.IDcontable) as IDcontableinactivar
		from EContables a	

		inner join ConceptoContableE b
			on a.Ecodigo = b.Ecodigo
			and a.Cconcepto = b.Cconcepto				
			and (
				not exists( select 1 
							from UsuarioConceptoContableE uc 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.Cconcepto = uc.Cconcepto
							and a.Ecodigo = uc.Ecodigo
				) or b.Cconcepto in (select a.Cconcepto
					from ConceptoContableE a, UsuarioConceptoContableE b
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.Cconcepto = b.Cconcepto
					and a.Ecodigo = b.Ecodigo
					and b.Usucodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
				)
			)
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif inter eq "S">
			and a.ECtipo = 20
		<cfelse>
			<cfif isdefined("paramretro") and paramretro eq 2>
				<!--- Para listar solamente asientos retroactivos --->
				and a.ECtipo = 2
			<cfelse>	
				and a.ECtipo = 0
			</cfif>
		</cfif>
				
		<cfif isdefined("Llote")  and len(trim(Llote)) and Llote NEQ -1>
			and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Llote#">
		</cfif>
		<cfif isdefined("Lpoliza") and Trim(Len(Lpoliza)) GT 0>
			and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lpoliza#">
		</cfif>
		<cfif isdefined("Ldescripcion") and len(trim(Ldescripcion)) GT 0>
			and upper(a.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Ldescripcion)#%">
		</cfif>
		<cfif isdefined("Lfecha") and len(trim(Lfecha)) GT 0 and LSisdate(Lfecha)>
			and a.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Lfecha)#">
		</cfif>
		<cfif isdefined("Lperiodo") and len(trim(Lperiodo)) and Lperiodo NEQ -1>
			and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Lperiodo#">
		</cfif>
		<cfif isdefined("Lmes") and len(trim(Lmes)) and Lmes neq -1>
			and a.Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Lmes#">
		</cfif>
		<cfif isdefined("form.ECusuario") and len(trim(form.ECusuario)) and form.ECusuario NEQ 'Todos'>
			and a.ECusuario = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ECusuario#">
		</cfif>
		<cfif isdefined("LfechaGen") and len(trim(LfechaGen)) GT 0 and LSisdate(LfechaGen)>
			and a.ECfechacreacion >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LfechaGen)#">
		</cfif>
		<cfif isdefined("form.origen") and len(trim(form.origen)) GT 0 >
			and upper(a.Oorigen)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.origen)#%">
		</cfif>
		order by Efecha desc, a.Cconcepto, a.Edocumento, a.Eperiodo, a.Emes				
	</cfquery>
	<cfquery name="rsUsuarios" datasource="#Session.DSN#">
		select  'Todos' as ECusuario, 'Todos' as ECusuarioDESC , 0 as orden
		union 
		select distinct ECusuario, ECusuario as ECusuarioDESC, 1 as orden
		  from EContables
		  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

<!--- 
	PINTADO DEL FORM
--->

		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cfif isdefined("url.LfechaGen") and not isdefined("form.LfechaGen")>
			<cfset form.LfechaGen = url.LfechaGen>
		</cfif>
		
		<!--- *** Asigna a la variable navegacion los filtros  --->
		<cfset navegacion = "">
		<cfif isdefined("form.Llote") and len(trim(form.Llote)) >
			<cfset navegacion = navegacion & "&Llote=#form.Llote#">
		</cfif>
		<cfif isdefined("form.Lpoliza") and len(trim(form.Lpoliza)) >
			<cfset navegacion = navegacion & "&Lpoliza=#form.Lpoliza#">
		</cfif>
		<cfif isdefined("Ldescripcion") and len(trim(Ldescripcion)) GT 0>
			<cfset navegacion = navegacion & "&Ldescripcion=#Ucase(Ldescripcion)#">
		</cfif>

		<cfif isdefined("Lfecha") and len(trim(Lfecha)) GT 0 and LSisdate(Lfecha)>
			<cfset navegacion = navegacion & "&Lfecha=#Lfecha#">
		</cfif>
		<cfif isdefined("Lperiodo") and len(trim(Lperiodo)) and Lperiodo NEQ -1>
			<cfset navegacion = navegacion & "&Lperiodo=#Lperiodo#">
		</cfif>
		<cfif isdefined("Lmes") and len(trim(Lmes)) and Lmes neq -1>
			<cfset navegacion = navegacion & "&Lmes=#Lmes#">
		</cfif>
		
		<cfif isdefined("form.ECusuario") and len(trim(form.ECusuario))>
			<cfset navegacion = navegacion & "&ECusuario=#form.ECusuario#">
		</cfif>
		
		<cfif isdefined("LfechaGen") and len(trim(LfechaGen)) GT 0 and LSisdate(LfechaGen)>
			<cfset navegacion = navegacion & "&LfechaGen=#LfechaGen#">
		</cfif>
		<cfif isdefined("form.ver") and len(trim(form.ver)) GT 0>
			<cfset navegacion = navegacion & "&ver=#form.ver#">
		</cfif>
		<cfif isdefined("form.origen") and len(trim(form.origen)) GT 0>
			<cfset navegacion = navegacion & "&origen=#form.origen#">
		</cfif>
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
		<cfset PolizaNum = t.Translate('PolizaNum','La p&oacute;liza debe ser num&eacute;rica.')>
		
		<cfif inter eq "S">
			<cfset TituloP = 'Lista de Documentos Contables Intercompa&ntilde;&iacute;as'>
		<cfelse>			
			<cfif isdefined("paramretro")>
				<cfset TituloP = 'Lista de Documentos Contables Retroactivos'>
			<cfelse>	
				<cfset TituloP = 'Lista de Documentos Contables'>
			</cfif>
		</cfif>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aplicaci&oacute;n Masiva de Documentos Contables'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
						
			<cfoutput>
			<cfform action="listaDocumentosContablesMasiva.cfm" method="post" name="formfiltro" style="margin:0;">
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
					<tr> 
						<td><b>Lote</b></td>
						<td><b>#PolizaE#</b></td>
						<td><b>Descripci&oacute;n</b></td>
						<td><b>Per&iacute;odo</b></td>
						<td><b>Mes</b></td>
						<td nowrap><b>Fecha Doc.</b></td>
						<td><b>&nbsp;</b></td>
						<td><b>&nbsp;</b></td>
					</tr>
					<cfif isdefined("paramretro") and paramretro eq 2>
					<tr>
						<td colspan="8">
							<input type="hidden" name="paramretro" value="#paramretro#">
						</td>
					</tr>
					</cfif>
					<tr> 
						<td> 
							<select name="lote">
								<option value="-1">Todos</option>
								<cfloop query="rsLotes"> 
									<option value="#Cconcepto#"<cfif Llote eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop> 
							</select>
						</td>
						<td>
							<cfinput type="text" name="poliza" message="#PolizaNum#" maxlength="5" size="5" validate="integer" value="#Lpoliza#">
						</td>
						<td>
							<input name="descripcion" type="text" size="50" maxlength="100" value="#Ldescripcion#"> 
						</td>
						<td>
							<select name="periodo">
								<option value="-1">Todos</option>
								<cfloop query="rsPer">
									<option value="#Eperiodo#" <cfif Lperiodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
								</cfloop>
							</select>
						</td>
						<td>
							<select name="mes">
								<option value="-1">Todos</option>				  
								<cfloop query="rsMeses">
									<option value="#VSvalor#"<cfif Lmes eq VSvalor>selected</cfif>>#VSdesc#</option>
								</cfloop>	
							</select>
						</td>
						<td>
							<cf_sifcalendario name="fecha" value="#LSDateFormat(Lfecha,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td><input type="submit" name="bFiltrar" value="Filtrar"></td>
						<td><input type="submit" name="bLimpiar" value="Limpiar"></td>
					</tr>
					<tr>
					  <td nowrap>&nbsp;</td>
					  <td><b>Ver</b></td>
					  <td nowrap><b>Usuario que Gener&oacute; </b></td>
					  <td><b>Origen del Asiento</b></td>
					  <td>&nbsp;</td>
					  <td nowrap><b>Fecha Gen.</b></td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
			  		</tr>
					<tr>
					  <td>&nbsp;</td>
					  <td><input type="text" name="ver" size="5" maxlength="5" value="<cfif isdefined('form.ver')>#form.ver#</cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
					  <td>
                          <!--- <cf_sifusuarioE form="formfiltro" idusuario="#form.Usucodigo#" size="40"  frame="frame1"> --->
						  <select name="ECusuario">
								<cfloop query="rsUsuarios">
									<option value="#rsUsuarios.ECusuario#"  <cfif isdefined("form.ECusuario") and form.ECusuario eq rsUsuarios.ECusuario>select</cfif> >#rsUsuarios.ECusuarioDESC#</option>
								</cfloop>
							</select>
                      </td>
					  <td><input name="origen" type="text" size="5" maxlength="4" value="<cfif isdefined("form.origen")>#form.origen#</cfif>"></td>
					  <td>&nbsp;</td>
					  <td> <cf_sifcalendario name="fechaGen" value="#LSDateFormat(LfechaGen,'dd/mm/yyyy')#" form="formfiltro"> </td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				    </tr>   
					<tr> 
						<td colspan="8">
								<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);">
								<label for="chkTodos">Seleccionar Todos</label>
						</td>
					</tr>
			</table>
			</cfform>
			</cfoutput>

			<cfoutput>			
			<cfset V_irA = "listaDocumentosContablesMasiva-sql.cfm?inter=#inter#">
			<!--- 
			<cfif isdefined("paramretro") and paramretro eq 2>				
				<cfset V_irA = "DocumentosContables#sufix#.cfm?inter=#inter#&paramretro=#paramretro#">
			<cfelse>
				<cfset V_irA = "DocumentosContables#sufix#.cfm?inter=#inter#">
			</cfif> --->
			</cfoutput>			
			
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="Cdescripcion,Edocumento,Edescripcion,Efecha,Eperiodo,Emes, Oorigen, ECfechacreacion, balanceada"/>
				<cfinvokeargument name="etiquetas" value="Lote, #PolizaE#, Descripci&oacute;n, Fecha Doc., Periodo, Mes, Origen, Fecha Gen., &nbsp;"/>
				<cfinvokeargument name="formatos" value="V,V,V,D,V,V,V,D,V"/>
				<cfinvokeargument name="align" value="left, left, left, center, center, center, center, center, center"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="showLink" value="false"/>				
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="keys" value="IDcontable"/>
				<cfinvokeargument name="irA" value="#V_irA#"/>
				<cfinvokeargument name="formname" value="form1"/>
				<cfinvokeargument name="botones" value="Aplicar, Regresar"/>
				<cfinvokeargument name="maxrows" value="0"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="inactivecol" value="IDcontableinactivar"/>
			</cfinvoke>
				
		<script language="javascript" type="text/javascript">
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
			function funcRegresar(){
				location.href = 'listaDocumentosContables.cfm';
			 return false
			}
			function funcAplicar(){
				var aplica = false;
				if (document.form1.chk) {
					if (document.form1.chk.value) {
						aplica = document.form1.chk.checked;
					} else {
						for (var i=0; i<document.form1.chk.length; i++) {
							if (document.form1.chk[i].checked) { 
								aplica = true;
								break;
							}
						}
					}
				}
				if (aplica) {
					return (confirm("¿Está seguro de que desea aplicar los documentos seleccionadas?"));
				} else {
					alert('Debe seleccionar al menos un documento antes de Aplicar');
					return false;
				}
	
			}
		</script>
		
		<cf_web_portlet_end>
	<cf_templatefooter>