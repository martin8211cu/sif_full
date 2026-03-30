<cf_templateheader title="Inventarios - Costos de Producci&oacute;n ">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Costos de Producci&oacute;n'>
		<script language="javascript" type="text/jscript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<!--- 
			Hecho por	: Rodolfo Jiménez Jara
			Fecha		: 05/09/2005
			Solicitada 	: Román Rodríguez
			Comentarios	: Se puso por defecto que navegación si el periodo , mes no vienen definidos en el form, use los
			del Periodo y mes actuales.
		 --->
		<cfquery name="rsPeriodoActual" datasource="#session.dsn#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 50
		</cfquery>	
		<cfset PeriodoActual = rsPeriodoActual.Pvalor>
		
		<cfquery name="rsMesActual" datasource="#session.dsn#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 60
		</cfquery>		
		<cfset MesActual = rsMesActual.Pvalor>
		
					
						
		<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
		<cfif isdefined("url.CTDperiodo") and not isdefined("form.CTDperiodo") >
			<cfset form.CTDperiodo = url.CTDperiodo >
		</cfif>
		
		<cfif isdefined("url.CTDmes") and not isdefined("form.CTDmes") >
			<cfset form.CTDmes = url.CTDmes >
		</cfif>
			
		<!--- *** Asigna a la variable navegacion los filtros  --->
		<cfset navegacion = "">
		<cfif isdefined("form.CTDperiodo") and len(trim(form.CTDperiodo)) >
			<cfset navegacion = navegacion & "&CTDperiodo=#form.CTDperiodo#">
		<cfelseif isdefined("rsPeriodoActual") and len(trim(rsPeriodoActual.Pvalor))>
			<cfset navegacion = navegacion & "&CTDperiodo=#rsPeriodoActual.Pvalor#">
		</cfif>
		
		<cfif isdefined("form.CTDmes") and len(trim(form.CTDmes)) >
			<cfset navegacion = navegacion & "&CTDmes=#form.CTDmes#">
		<cfelseif isdefined("rsMesActual") and len(trim(rsMesActual.Pvalor))>
			<cfset navegacion = navegacion & "&CTDmes=#rsMesActual.Pvalor#">
		</cfif>
				
		<form name="form1" action="">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				<tr><td colspan="5"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td></tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td width="34%" align="right"><label for="CTDperiodo"><strong>Período:&nbsp;</strong></label></td>
					<td width="15%">
						
						<cfoutput>
							<select name="CTDperiodo" onChange="javascript: form1.submit();">
								<option value="#rsPeriodoActual.Pvalor#" <cfif isdefined("form.CTDperiodo") and rsPeriodoActual.Pvalor EQ form.CTDperiodo>selected</cfif>>#HTMLEditFormat(rsPeriodoActual.Pvalor)#</option>
								<option value="#rsPeriodoActual.Pvalor  - 1#" <cfif isdefined("form.CTDperiodo") and rsPeriodoActual.Pvalor - 1 EQ form.CTDperiodo>selected</cfif>>#HTMLEditFormat(rsPeriodoActual.Pvalor - 1)# </option>
								<option value="#rsPeriodoActual.Pvalor  - 2#" <cfif isdefined("form.CTDperiodo") and rsPeriodoActual.Pvalor - 2 EQ form.CTDperiodo>selected</cfif>>#HTMLEditFormat(rsPeriodoActual.Pvalor - 2)#</option>
								<option value="#rsPeriodoActual.Pvalor  - 3#" <cfif isdefined("form.CTDperiodo") and rsPeriodoActual.Pvalor - 3 EQ form.CTDperiodo>selected</cfif>>#HTMLEditFormat(rsPeriodoActual.Pvalor - 3)#</option>
								<option value="#rsPeriodoActual.Pvalor  - 4#" <cfif isdefined("form.CTDperiodo") and rsPeriodoActual.Pvalor - 4 EQ form.CTDperiodo>selected</cfif>>#HTMLEditFormat(rsPeriodoActual.Pvalor - 4)#</option>								
							</select>
						</cfoutput>
					</td>
					<td width="6%" align="right"><label for="CTDmes"><strong>Mes:&nbsp;</strong></label></td>
					<td width="45%">
					
					<select name="CTDmes" onChange="javascript: form1.submit();">
                      <option value="1" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 1) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 1)>selected</cfif>> Enero </option>
                      <option value="2" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 2) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 2)>selected</cfif>> Febrero </option>
                      <option value="3" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 3) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 3)>selected</cfif>> Marzo </option>
                      <option value="4" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 4) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 4)>selected</cfif>> Abril </option>
                      <option value="5" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 5) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 5)>selected</cfif>> Mayo </option>
                      <option value="6" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 6) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 6)>selected</cfif>> Junio </option>
                      <option value="7" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 7) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 7)>selected</cfif>> Julio </option>
                      <option value="8" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 8) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 8)>selected</cfif>> Agosto </option>
                      <option value="9" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 9) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 9)>selected</cfif>> Setiembre </option>
                      <option value="10" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 10) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 10)>selected</cfif>> Octubre </option>
                      <option value="11" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 11) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 11)>selected</cfif>> Noviembre </option>
                      <option value="12" <cfif (isdefined("form.CTDmes") and form.CTDmes EQ 12) or (not isdefined("form.CTDmes") and rsMesActual.Pvalor EQ 12)>selected</cfif>> Diciembre </option>
                    </select></td>
					<td width="45%">
				</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>			
			</table>
		</form>
		<!--- CTDprecio --->
			<!-- En el Nuevocosto esta la cajita de texto que se pinta en la lista con el CTDcosto (digitable) una para cada CTDid concatenado con Costo ---->
			<!-- En el Costoanterior esta la cajita de texto donde guarda el costo traido de la BD's una para cada CTDid concatenado con Costoanterior ---->
			<!---En el input IDS se guardan los CTDid que estan en la pagina actual de la lista ---->
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name="rsLista" datasource="#session.DSN#">
				Select '<input 
						type=''text'' size=''20'' maxlength=''18'' style=''text-align: right'' 
						onFocus=''this.value=qf(this); this.select();'' 
						onBlur=''javascript: fm(this,2);'' 
						onKeyUp=''if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}''
						name=''Costo' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# ''' 
						value=''' #_Cat# <cf_dbfunction name="to_char" args="CTDcosto"> #_Cat# '''>
						<script>fm(document.lista.Costo' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# ',2);</script>' as Nuevocosto, 
						'<input type=hidden 
							name=''Costoanterior' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# ''' 
							value=''' #_Cat# <cf_dbfunction name="to_char" args="CTDcosto"> #_Cat# '''>' as Costoanterior,
						
						'<input 
						type=''text'' size=''20'' maxlength=''18'' style=''text-align: right'' 
						onFocus=''this.value=qf(this); this.select();'' 
						onBlur=''javascript: fm(this,2);'' 
						onKeyUp=''if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}''
						name=''CTDprecio' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# ''' 
						value=''' #_Cat# <cf_dbfunction name="to_char" args="CTDprecio"> #_Cat# '''>
						<script>fm(document.lista.CTDprecio' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# ',2);</script>' as NuevoCTDprecio, 
						'<input type=hidden 
							name=''CTDprecioanterior' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# ''' 
							value=''' #_Cat# <cf_dbfunction name="to_char" args="CTDprecio"> #_Cat# '''>' as CTDprecioanterior,							
						'<input type=hidden 
							name=IDS
							value=''' #_Cat# <cf_dbfunction name="to_char" args="CTDid"> #_Cat# '''>' as IDS,												
					a.CTDid, a.Aid, a.CTDperiodo, a.CTDmes, a.CTDcosto, 
					b.Acodigo, b.Adescripcion
				from CostoProduccionSTD a
					inner join Articulos b
						on a.Aid = b.Aid
						and a.Ecodigo = b.Ecodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined("form.CTDperiodo") and len(trim(form.CTDperiodo))>
						and CTDperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTDperiodo#">
					<cfelse><!---  --->
						and CTDperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#PeriodoActual#">
					</cfif>
					<cfif isdefined("form.CTDmes") and len(trim(form.CTDmes))>
						and CTDmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTDmes#">
					<cfelse><!---  --->
						and CTDmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#MesActual#">
					</cfif>			
				Order by  CTDperiodo desc, CTDmes, b.Acodigo  
			</cfquery>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="Acodigo, Adescripcion, Costoanterior,CTDprecioanterior, IDS, Nuevocosto, NuevoCTDprecio"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Art&iacute;culo, &nbsp;, &nbsp;,&nbsp;,Costo,Precio"/>
				<cfinvokeargument name="formatos" value="S,S,V,V,V,V,V"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="CTDid"/>
				<cfinvokeargument name="showlink" value="false"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="botones" value="Actualizar"/>
				<cfinvokeargument name="maxrows" value="12"/> 
			</cfinvoke>
	
			<script language='javascript' type='text/JavaScript'>
				function funcActualizar(){				
					var parametros
					parametros="?CTDperiodo="+document.form1.CTDperiodo.value+"&CTDmes="+document.form1.CTDmes.value 			
					document.lista.action = 'SQLCostosProduccion.cfm'+parametros;
				}
			</script>
		
	<cf_web_portlet_end>	
<cf_templatefooter>
