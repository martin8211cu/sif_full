<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 27-2-2006.
		Motivo: Se concatena el periodo con el mes, se agrega la columna del monto, se ordenan las columnas de la 
		lista: Lote, póliza, descripción, período, fecha, monto.
	Modificado por Gustavo Fonseca H.
		Fecha: 28-2-2006.
		Motivo: Se agrega filtro de usuario en la lista.
	Modificado por Steve Vado Rodríguez.
		Fecha: 01-3-2006.
		Motivo: Se agregó la fecha de aplicación del asiento como una columna más.
	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
			rendimiento de la pantalla.
 --->
<cfinclude template="Funciones.cfm">		
<cfset periodo="#get_val(30).Pvalor#">	   	
<cfset mes="#get_val(40).Pvalor#">
        
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		 
      SIF - Contabilidad General
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			
				<td valign="top">
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cfif isdefined("url.Cconcepto") and not isdefined("form.Cconcepto")>
				<cfset form.Cconcepto = url.Cconcepto >	
		</cfif>
		<cfif isdefined("url.Eperiodo") and not isdefined("form.Eperiodo")>
				<cfset form.Eperiodo = url.Eperiodo >	
		</cfif>
		<cfif isdefined("url.Emes") and not isdefined("form.Emes")>
				<cfset form.Emes = url.Emes >	
		</cfif>
		<cfif isdefined("url.Edocumento") and not isdefined("form.Edocumento")>
				<cfset form.Edocumento = url.Edocumento >	
		</cfif>
		<cfif isdefined("url.Edescripcion") and not isdefined("form.Edescripcion")>
				<cfset form.Edescripcion = url.Edescripcion >	
		</cfif>
		<cfif isdefined("url.fecha") and not isdefined("form.fecha")>
				<cfset form.fecha = url.fecha >	
		</cfif>
		<cfif isdefined("url.ECusuario") and not isdefined("form.ECusuario")>
				<cfset form.ECusuario = url.ECusuario>	
		</cfif>

		<cfquery datasource="#Session.DSN#" name="rsConcepto">
			select Ecodigo, Cconcepto, Cdescripcion, ts_rversion 
			from ConceptoContableE 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			
			union all
			
			Select null as Ecodigo ,  -1 as Cconcepto, 'Todos' as Cdescripcion, null as ts_rversion
			from dual
		</cfquery>	  	
		<cfquery name="rsUsuarios" datasource="#Session.DSN#">
			select  'Todos' as ECusuario, 'Todos' as ECusuarioDESC , 0 as orden
			union 
			select distinct ECusuario, ECusuario as ECusuarioDESC, 1 as orden
			  from HEContables
			  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              	<cfif isdefined("form.EPeriodo") and isdefined("form.EMes") and form.Eperiodo GT 0 and form.Emes GT 0>
                   and Eperiodo = #form.EPeriodo#
                   and Emes = #form.Emes#
                <cfelse>
                   and Eperiodo = #Periodo#
                   and Emes = #Mes#
                </cfif>
	  	  	order by orden, ECusuarioDESC 
		</cfquery>
		
		
		
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
		<cfset ConsPol = t.Translate('ConsPol','Consulta de P&oacute;lizas Contabilizadas')>
		<cfset PolizaVal = t.Translate('PolizaVal','El valor de la P&oacute;liza')>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#ConsPol#'>
		
				<cfinclude template="../../portlets/pNavegacionCG.cfm">
		
				<cfquery name="rsConceptos" datasource="#Session.DSN#">
					select Cconcepto, Cdescripcion from ConceptoContableE 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
 				<!---<cfquery name="rsPeriodos" datasource="#Session.DSN#">
					select distinct Eperiodo 
					from HEContables
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery> --->
				<cfquery name="rsPeriodos" datasource="#Session.DSN#">
					select distinct Speriodo as Eperiodo
					from CGPeriodosProcesados
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					order by Speriodo desc
				</cfquery>
				
				<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
				<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
				<cfoutput>
				<form style="margin:0; " action="OBobraLiquidacion_sql.cfm?OP=L&OBOid=#url.OBOid#" name="filtro" method="post" onsubmit="return sinbotones()">
				</cfoutput>

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					<tr> 
						<td colspan="7" align="center"><strong>Liquidación Externa de la Obra:</strong></td>
					</tr>
					<tr> 
						<td colspan="7" align="center">Debe indicar la Póliza de Liquidación de la Obra</td>
					</tr>
					<tr> 
						<td>&nbsp;</td>
					</tr>
					<tr> 
						<td ><strong>Lote</strong>&nbsp;</td>
						<td align="left"><cfoutput><strong>#PolizaE#</strong></cfoutput>&nbsp;</td>
						<td ><strong>Descripci&oacute;n</strong>&nbsp;</td>
						<td ><strong>Mes</strong>&nbsp;</td>
						<td ><strong>Per&iacute;odo</strong>&nbsp;</td>
						<td ><strong>Fecha </strong>&nbsp;</td>
						<td ><strong>Usuario</strong>&nbsp;</td>
					</tr>

					<tr> 
						<td> 
							<select name="Cconcepto">
								<option value="-1" <cfif isdefined("Form.Cconcepto") AND Form.Cconcepto EQ "-1">selected</cfif>>(Todos)</option>
								<cfoutput query="rsConceptos"> 
									<option value="#rsConceptos.Cconcepto#" <cfif isdefined("Form.Cconcepto") AND rsConceptos.Cconcepto EQ Form.Cconcepto>selected</cfif>>#rsConceptos.Cdescripcion#</option>
								</cfoutput> 
							</select>
						</td>
						<td align="left"> 
							<input name="Edocumento" type="text" id="Edocumento" size="12" maxlength="15" alt="#PolizaVal#" value="<cfif isdefined("Form.Edocumento")><cfoutput>#Form.Edocumento#</cfoutput></cfif>" onblur="fm(this,0);" onfocus="javascript:this.value=qf(this);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
						<td> 
							<input name="Edescripcion" type="text" id="Edescripcion" size="20" maxlength="100" value="<cfif isdefined("Form.Edescripcion")><cfoutput>#Form.Edescripcion#</cfoutput></cfif>">
						</td>
						
						<td> 
							<select name="Emes" size="1">
								<option value="-1" <cfif isdefined("Form.Emes") AND Form.Emes EQ "-1">selected</cfif>>(Todos)</option>
								<cfloop index="i" from="1" to="#ListLen(meses)#">
									<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("Form.Emes") AND Form.Emes EQ i>selected<cfelseif not isdefined("Form.Emes") AND mes EQ i>selected</cfif>> 
									<cfoutput>#ListGetAt(meses,i)#</cfoutput> </option>
								</cfloop>
							</select>
						</td>

						<td> 
							<select name="Eperiodo">
								<option value="-1" <cfif isdefined("Form.Eperiodo") AND Form.Eperiodo EQ "-1">selected</cfif>>(Todos)</option>
								<cfoutput query="rsPeriodos"> 
									<option value="#rsPeriodos.Eperiodo#" <cfif isdefined("Form.Eperiodo") AND rsPeriodos.Eperiodo EQ Form.Eperiodo>selected<cfelseif not isdefined("Form.Eperiodo") AND periodo EQ rsPeriodos.Eperiodo>selected</cfif>>#rsPeriodos.Eperiodo#</option>
								</cfoutput> 
							</select>
						</td>
						<td nowrap> 
							<cfset value = ''>
							<cfif isdefined("form.fecha") and len(trim(form.fecha)) gt 0>
								<cfset value = form.fecha >
							</cfif>
							<cf_sifcalendario form="filtro" value="#value#">
						</td>
						<td>
						  	<cfoutput>
								<select name="ECusuario">
									<cfloop query="rsUsuarios">
										<option value="#rsUsuarios.ECusuario#" <cfif isdefined("form.ECusuario") and form.ECusuario eq rsUsuarios.ECusuario>selected</cfif> >#rsUsuarios.ECusuarioDESC#</option>
									</cfloop>
								</select>
							</cfoutput>
                      	</td>
						<td nowrap style="vertical-align:middle ">
							<input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Filtrar">
						</td>
						</tr>
						<tr>
						<td colspan="8" align="right">
							<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:Limpiar(this.form);">
							<input type="button" value="Regresar" onclick='location.href="OBobra.cfm?OBOid=<cfoutput>#Arguments.OBOid#</cfoutput>";' />
						</td>
						
						
						</tr>
					
				</table>
				</form>	
				<cfset navegacion = "">
				<cfinclude template="../../Utiles/sifConcat.cfm">
				<cfquery name="rsLista" datasource="#Session.DSN#">
					select top 300
							a.IDcontable, 
							a.Edocumento, 
							substring(a.Edescripcion,1,60) as Edescripcion,
							<cf_dbfunction name="to_char" args="a.Eperiodo"> #_Cat# ' / ' #_Cat#  <cf_dbfunction name="to_char" args="a.Emes"> as fecha,  
							a.Efecha, 
							b.Cdescripcion,
							coalesce((
								select sum(Dlocal)
								from HDContables d
								where d.IDcontable = a.IDcontable
								  and d.Dmovimiento = 'D'
								  ), 0.00) as Monto,
							a.ECfechaaplica as fechaAplica,
							a.Cconcepto as Cconcepto
					from HEContables a
						inner join ConceptoContableE b
							 on b.Ecodigo   = a.Ecodigo
							and b.Cconcepto = a.Cconcepto
					where a.Ecodigo = #Session.Ecodigo#
					<cfif isdefined("Form.Cconcepto") and (Len(Trim(Form.Cconcepto)) NEQ 0) and (Form.Cconcepto NEQ "-1")>
						and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cconcepto#">
						<cfset navegacion = navegacion & "&Cconcepto=#form.Cconcepto#">
					</cfif>
					<cfif isdefined("Form.Eperiodo") and (Len(Trim(Form.Eperiodo)) NEQ 0) and (Form.Eperiodo NEQ "-1")>
						and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eperiodo#">
						<cfset navegacion = navegacion & "&Eperiodo=#form.Eperiodo#">
					<cfelseif  isdefined("Form.Eperiodo") and Len(Trim(Form.Eperiodo))>
						<cfset navegacion = navegacion & "&Eperiodo=#form.Eperiodo#">
					<cfelseif not isdefined("Form.Eperiodo")>
						and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">
						<cfset navegacion = navegacion & "&Eperiodo=#periodo#">
					</cfif>
					<cfif isdefined("Form.Emes") and (Len(Trim(Form.Emes)) NEQ 0) and (Form.Emes NEQ "-1")>
						and a.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Emes#">
						<cfset navegacion = navegacion & "&Emes=#form.Emes#">
					<cfelseif isdefined("Form.Emes") and Len(Trim(Form.Emes)) NEQ 0>
						<cfset navegacion = navegacion & "&Emes=#form.Emes#">
					<cfelseif not isdefined("Form.Emes")>
						and a.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
						<cfset navegacion = navegacion & "&Emes=#mes#">
					</cfif>
					<cfif isdefined("Form.Edocumento") and (Len(Trim(Form.Edocumento)) NEQ 0)>
						and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Edocumento#">
						<cfset navegacion = navegacion & "&Edocumento=#Form.Edocumento#">
					</cfif>
					<cfif isdefined("Form.Edescripcion") and (Len(Trim(Form.Edescripcion)) NEQ 0)>
						and upper(a.Edescripcion) like '%#Ucase(Form.Edescripcion)#%'
						<cfset navegacion = navegacion & "&Edescripcion=#Form.Edescripcion#">
					</cfif>
					<cfif isdefined("Form.fecha") and (Len(Trim(Form.fecha)) NEQ 0)>			
						and a.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fecha)#">
						<cfset navegacion = navegacion & "&fecha=#Form.fecha#">
					</cfif>
					<cfif isdefined("Form.ECusuario") and form.ECusuario NEQ 'Todos'>
						and a.ECusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ECusuario#">
						<cfset navegacion = navegacion & "&ECusuario=#form.ECusuario#">
					<cfelse>
						<cfset navegacion = navegacion & "&ECusuario=Todos">
					</cfif>
 					order by a.Cconcepto, a.Edocumento, a.Eperiodo desc, a.Emes desc 				
				</cfquery>			
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				 returnvariable="pLista">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value=" Cdescripcion, Edocumento, Edescripcion, fecha, Efecha, fechaAplica, Monto"/>
					<cfinvokeargument name="etiquetas" value="Lote,#PolizaE#,Descripción,Período,Fecha, Aplic&oacute; Asiento, Monto"/>
 					<cfinvokeargument name="formatos" value="V,V,V,V,D,D,M"/>
					<cfinvokeargument name="align" value="left,left,left,left,left,left,right"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="irA" value="OBobraLiquidacion_sql.cfm?OP=L&ver&OBOid=#url.OBOid#"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="MaxRows" value="18"/>
				</cfinvoke>	
 		<cf_web_portlet_end>
		<script language="JavaScript1.2">
			function Limpiar(f) {
				f.Cconcepto.selectedIndex = 0;
				for (var i=0; i<f.Eperiodo.length; i++) {
					if (f.Eperiodo[i].value == '<cfoutput>#periodo#</cfoutput>') {
						f.Eperiodo.selectedIndex = i;
						break;
					}
				}
				f.Emes.selectedIndex = <cfoutput>#mes#</cfoutput>;
				f.Edocumento.value = "";
				f.Edescripcion.value = "";
				f.fecha.value = "";
				f.ECusuario.selectedIndex = 1;
			}
		</script>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>