<cfinclude template="Funciones.cfm">		
<cfset periodo="#get_val(30).Pvalor#">	   	
<cfset mes="#get_val(40).Pvalor#">

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
	
	Se modifica para que sostenga el filtro de cierre mensual y no ponga el cero en el campo de poliza.
--->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfsetting enablecfoutputonly="no">
<cfif isdefined("url.CHKMesCierre") and not isdefined("form.CHKMesCierre")>
	<cfset form.CHKMesCierre = url.CHKMesCierre>
</cfif>
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
<cfif isdefined("url.fechaaplica") and not isdefined("form.fechaaplica")>
	<cfset form.fechaaplica = url.fechaaplica>	
</cfif>
<cfif isdefined("url.btnfiltrar") and not isdefined("form.btnfiltrar")>
	<cfset form.btnfiltrar = url.btnfiltrar>	
</cfif>

<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select distinct ECusuario, ECusuario as ECusuarioDESC
	  from HEContables
	  where Ecodigo = #Session.Ecodigo#
	<cfif isdefined("form.EPeriodo") and isdefined("form.EMes") and form.Eperiodo GT 0 and form.Emes GT 0>
       and Eperiodo = #form.EPeriodo#
       and Emes = #form.Emes#
    <cfelse>
       and Eperiodo = #Periodo#
       and Emes = #Mes#
    </cfif>
	order by ECusuario
</cfquery>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select Cconcepto, Cdescripcion 
    from ConceptoContableE 
	where Ecodigo = #Session.Ecodigo#
	order by Cconcepto
</cfquery>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = #Session.Ecodigo#
	order by Speriodo desc
</cfquery>

<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>


<cfset LvarTituloConsulta = "Consulta de P&oacute;lizas Contabilizadas">
<cfif isdefined("LvarAsientoRecursivo")>
	<cfset LvarTituloConsulta = "Consulta de Asientos Recurrentes">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset ConsPol = t.Translate('ConsPol',LvarTituloConsulta)>
<cfset PolizaVal = t.Translate('PolizaVal','El valor de la P&oacute;liza')>

<cfset navegacion = "">
<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_dbfunction name="to_char" args="a.Eperiodo" returnvariable='LvarEperiodo'>
<cf_dbfunction name="to_char" args="a.Emes" returnvariable='LvarEmes'>
<cfset LvarFecha = "#LvarEperiodo# #_Cat# ' / ' #_Cat# #LvarEmes#">
<cfset LvarMaxRows = 300>
<cfset LvarTop = ''>
<cfset dbtype = Application.dsinfo[session.dsn].type>
<cfif dbtype eq 'sybase'>
	<cfset LvarTop = 'top #LvarMaxRows#'>
</cfif>


<cfquery name="rsLista" datasource="#Session.DSN#" maxrows="#LvarMaxRows#">
	select	#LvarTop#
			a.IDcontable, 
			a.Edocumento, 
			<cf_dbfunction name='string_part' args="a.Edescripcion,1,60"> as Edescripcion,
			 #preservesinglequotes(LvarFecha)#  as fecha,  
			a.Efecha, 
			coalesce((
				select sum(Dlocal)
				from HDContables d
				where d.IDcontable = a.IDcontable
				  and d.Dmovimiento = 'D'
				  ), 0.00) as Monto,
			a.ECfechaaplica as fechaAplica,
			a.Cconcepto as Cconcepto
	from HEContables a
    	<cfif isdefined("LvarAsientoRecursivo")>
        	inner join AsientosRecursivos b
            	on b.IDcontable = a.IDcontable
                and b.Ecodigo = a.Ecodigo
        </cfif>
	where a.Ecodigo = #Session.Ecodigo#
	<cfif isdefined("Form.CHKMesCierre")>
		and a.ECtipo = 1
		<cfset navegacion = navegacion & "&CHKMesCierre=#form.CHKMesCierre#">
	<cfelse>
		and a.ECtipo <> 1
	</cfif>
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
		and a.Efecha >= #LSParseDateTime(Form.fecha)#
		<cfset navegacion = navegacion & "&fecha=#Form.fecha#">
	</cfif>
	<cfif isdefined("Form.fechaaplica") and (Len(Trim(Form.fechaaplica)) NEQ 0)>			
		and a.ECfechaaplica >= #LSParseDateTime(Form.fechaaplica)#
		and a.ECfechaaplica <= #dateadd('d', 1, LSParseDateTime(Form.fechaaplica))#
		<cfset navegacion = navegacion & "&fechaaplica=#Form.fechaaplica#">
	</cfif>
	<cfif isdefined("Form.ECusuario") and form.ECusuario NEQ 'Todos'>
		and a.ECusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ECusuario#">
		<cfset navegacion = navegacion & "&ECusuario=#form.ECusuario#">
	<cfelse>
		<cfset navegacion = navegacion & "&ECusuario=Todos">
	</cfif>
    <cfif not isdefined('form.btnfiltrar')>
    	and 1 = 2
    <cfelse>
    	<cfset navegacion = navegacion & "&btnfiltrar=#form.btnfiltrar#">
    </cfif>
	order by a.Cconcepto, a.Edocumento, a.Eperiodo desc, a.Emes desc			
</cfquery>
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Contabilidad General">
	<cfinclude template="../../portlets/pNavegacionCG.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#ConsPol#'>
	    <cfset LvarActionForm = 'PolizaContable.cfm'>
		<cfif isdefined("LvarAsientoRecursivo")>
        	<cfset LvarActionForm = 'AsientosRecursivos.cfm'>
        </cfif>
		<form style="margin:0; " action="<cfoutput>#LvarActionForm#</cfoutput>" name="filtro" method="post">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
			<tr>
				<td colspan="6" align="center">
					<cfoutput>
					<strong>**  Al entrar a la pantalla deberá de escoger filtros y hacer click en filtrar para ver los asientos. La Lista tendr&aacute; un m&aacute;ximo de 300 registros.  Si no encuentra el asiento, por favor sea m&aacute;s específico en los filtros.</strong>
					<br>
					</cfoutput>
				</td>
			</tr>
			<tr> 
				<td ><strong>Lote</strong></td>
				<td align="left"><cfoutput><strong>#PolizaE#</strong></cfoutput></td>
				<td ><strong>Usuario</strong></td>
				<td colspan="2" ><strong>Descripci&oacute;n</strong></td>
			</tr>
			<tr>
				<td> 
					<select name="Cconcepto">
						<option value="-1" <cfif isdefined("Form.Cconcepto") AND Form.Cconcepto EQ "-1">selected</cfif>>(Todos)</option>
						<cfoutput query="rsConceptos"> 
							<option value="#rsConceptos.Cconcepto#" <cfif isdefined("Form.Cconcepto") AND rsConceptos.Cconcepto EQ Form.Cconcepto>selected</cfif>>#rsConceptos.Cconcepto#-#rsConceptos.Cdescripcion#</option>
						</cfoutput> 
					</select>
				</td>
				<td align="left"> 
					<input name="Edocumento" type="text" id="Edocumento" size="12" maxlength="15" alt="#PolizaVal#" value="<cfif isdefined("Form.Edocumento")><cfoutput>#Form.Edocumento#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13'){ this.value=this.value; }}" >
				</td>
				<td>
				  	<cfoutput>
						<select name="ECusuario">
						<option value="Todos" <cfif isdefined("Form.ECusuario") AND Form.ECusuario EQ "Todos">selected</cfif>>(Todos)</option>
						<cfloop query="rsUsuarios">
							<option value="#rsUsuarios.ECusuario#" <cfif isdefined("form.ECusuario") and form.ECusuario eq rsUsuarios.ECusuario>selected</cfif> >#rsUsuarios.ECusuarioDESC#</option>
						</cfloop>
						</select>
					</cfoutput>
				</td>
				<td colspan="2"> 
					<input name="Edescripcion" type="text" id="Edescripcion" size="50" maxlength="100" value="<cfif isdefined("Form.Edescripcion")><cfoutput>#Form.Edescripcion#</cfoutput></cfif>">
				</td>
				<td nowrap style="vertical-align:middle ">
					<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Poliza_contable.htm">
				</td>
			</tr>
			<tr> 
				<td ><strong>Mes</strong></td>
				<td ><strong>Per&iacute;odo</strong></td>
				<td ><strong>Fecha</strong></td>
				<td ><strong>Aplicaci&oacute;n</strong></td>
			</tr>
			<tr>
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
				<td nowrap> 
					<cfset value = ''>
					<cfif isdefined("form.fechaaplica") and len(trim(form.fechaaplica)) gt 0>
						<cfset value = form.fechaaplica>
					</cfif>
					<cf_sifcalendario name="fechaaplica" form="filtro" value="#value#">
				</td>
			</tr>
			<tr>
				<td nowrap>
					<input type="checkbox" id="CHKMesCierre" name="CHKMesCierre" value="1" tabindex="1" <cfif isdefined("form.CHKMesCierre")>checked</cfif>>
					<label for="CHKMesCierre">Cierre Anual</label>
				</td>
				<td colspan="5" align="right">
					<input name="btnExportar" type="submit" id="btnExporta2" value="Exportar" onClick="javascript:Exportar(this.form);">&nbsp;&nbsp; 
					<input name="btnFiltrar"  type="submit" id="btnFiltrar2" value="Filtrar" onClick="javascript:filtrar(this.form);">&nbsp;&nbsp; 
					<input name="btnLimpiar"  type="submit" id="btnLimpiar"  value="Limpiar" onClick="javascript:Limpiar(this.form);">
				</td>
			</tr>
		</table>
		</form>
        <cfset LvarIrA = 'SQLPolizaConta.cfm'>
		<cfif isdefined("LvarAsientoRecursivo")>
        	<cfset LvarIrA = 'SQLPolizaConta.cfm?LvarAsientoRecursivo=#LvarAsientoRecursivo#'>
        </cfif>
		<cfflush interval="120">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		 returnvariable="pLista">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Cconcepto, Edocumento, Edescripcion, fecha, Efecha, fechaAplica, Monto"/>
			<cfinvokeargument name="etiquetas" value="Lote,#PolizaE#,Descripción,Período,Fecha, Aplic&oacute; Asiento, Monto"/>
			<cfinvokeargument name="formatos" value="V,V,V,V,D,D,M"/>
			<cfinvokeargument name="align" value="right,right,left,left,left,left,right"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="irA" value="#LvarIrA#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="MaxRows" value="100"/>
		</cfinvoke>	
	<cf_web_portlet_end>
<cf_templatefooter>

<cfset LvarExportar = 'PolizaContableExcel.cfm'>
<cfif isdefined("LvarAsientoRecursivo")>
	<cfset LvarExportar = 'PolizaContableExcel.cfm?LvarAsientoRecursivo=#LvarAsientoRecursivo#'>
</cfif>
<script language="JavaScript1.2">
	function Limpiar(f) {
		f.action="PolizaContable.cfm";
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
	function Exportar(f) {
		f.action="<cfoutput>#LvarExportar#</cfoutput>";
		f.submit();
	}
	function filtrar(f) {
		f.action="<cfoutput>#LvarActionForm#</cfoutput>";
		f.submit();
	}
</script>
