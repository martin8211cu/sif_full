<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla.
 --->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsLotes" datasource="#Session.DSN#">
	select  a.Cconcepto, 
			<cf_dbfunction args="a.Cconcepto" name="to_char" datasource="#session.DSN#">  
			#_Cat# '-' #_Cat# Cdescripcion as Cdescripcion
	from ConceptoContableE a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and not exists ( 
			select 1 from UsuarioConceptoContableE b 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Cconcepto = b.Cconcepto
			and a.Ecodigo = b.Ecodigo
		)  
	UNION
	select a.Cconcepto, 
			<cf_dbfunction args="a.Cconcepto" name="to_char" datasource="#session.DSN#"> 
			#_Cat# '-' #_Cat# Cdescripcion as Cdescripcion
	from ConceptoContableE a
		inner join UsuarioConceptoContableE b
		on a.Cconcepto = b.Cconcepto
		and a.Ecodigo = b.Ecodigo
		and b.Usucodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
</cfquery>

<cfquery name="rsPer" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, 
		b.VSdesc 
	from Idiomas a
		inner join VSidioma b 
		on a.Iid = b.Iid
		and b.VSgrupo = 1
	where a.Icodigo = '#Session.Idioma#'
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>
<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select  'Todos' as ECusuario, 
			'Todos' as ECusuarioDESC , 
			0 as orden
	union 
	select 	distinct ECusuario, 
			ECusuario as ECusuarioDESC, 
			1 as orden
	from EContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by 3 
</cfquery>
<cfif not isdefined("form.Usucodigo")>
	<cfset form.Usucodigo = "">
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
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cfinclude template="Funciones.cfm">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaNum = t.Translate('PolizaNum','La p&oacute;liza debe ser num&eacute;rica.')>
<cfset ConceptoIni=t.Translate('LB_ConceptoIni','ConceptoXXX Inicial'>
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">
<cfoutput>
	<form action="DocumentosNoAplicados.cfm" method="post" name="formfiltro" style="margin:0;" onsubmit="return sinbotones()">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro" style="margin:0;">
			<tr> 
				<td nowrap="nowrap" class="fileLabel">Asiento Inicial&nbsp;</td>
				<td nowrap="nowrap" class="fileLabel">#ConceptoIni#</td>
				<td nowrap="nowrap" class="fileLabel">Per&iacute;odo Inicial</td>
				<td nowrap="nowrap" class="fileLabel">Mes Inicial</td>
				<td nowrap="nowrap" class="fileLabel">Fecha Inicial</td>
				<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
				<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>			
			<tr> 
				<td>
					<cf_conlis
						campos="EdocumentoI"
						desplegables="S"
						modificables="S"
						size="S"
						title="Lista Documentos Contables"
						tabla="EContables a"
						columnas="Edocumento as EdocumentoI
								, Cconcepto as loteini
								, Eperiodo as periodoini
								, Emes as mesini
								, Efecha as fechaIni
								, Edescripcion"
						filtro="a.Ecodigo = #Session.Ecodigo# 
								order by a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, a.Edocumento"
						desplegar="loteini
								, periodoini
								, mesini
								, fechaIni
								, EdocumentoI
								, Edescripcion"
						filtrar_por="Cconcepto
								, Eperiodo
								, Emes
								, Efecha
								, Edocumento
								, Edescripcion"
						requeridos="S,S,S,N,N,N"
						etiquetas="Concepto, Periodo, Mes, Fecha, Documento, Descripcion"
						formatos="I,I,I,D,I,S"
						align="right,right,right,center,right,left"
						asignar="EdocumentoI
								, loteini
								, periodoini
								, mesini
								, fechaIni"
						asignarformatos="I,C,C,C,D"
						MaxRows="20"
						MaxRowsQuery="250"
						form="formfiltro"
						debug="false"
						showEmptyListMsg="true"
						EmptyListMsg="--- No se encontraron documentos contables para los filtros definidos ---"
					/>
				</td>
				<td> 
					<select name="loteini" alt="Concepto Inicial">
						<option value="">Todos</option>
						<cfloop query="rsLotes">
							<option value="#Cconcepto#" <cfif isdefined("form.loteini") and form.loteini eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<select name="periodoini" alt="Periodo Inicial">
						<cfloop query="rsPer">
							<option value="#Eperiodo#" <cfif isdefined("periodo") and periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<select name="mesini" alt="Mes Inicial">
						<cfloop query="rsMeses">
							<option value="#VSvalor#"<cfif  isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<cfif isdefined("form.fechaIni")>
						<cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#" form="formfiltro" alt="Fecha Inicial">
					<cfelse>
						<cf_sifcalendario name="fechaIni" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="formfiltro" alt="Fecha Inicial">
					</cfif>
				</td>
				<td><input type="reset" name="bLimpiar" value="Limpiar"></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap="nowrap" class="fileLabel">Asiento Final&nbsp;</td>
				<td nowrap="nowrap" class="fileLabel">Concepto Final</td>
				<td nowrap="nowrap" class="fileLabel">Per&iacute;odo Final</td>
				<td nowrap="nowrap" class="fileLabel">Mes Final</td>
				<td nowrap="nowrap" class="fileLabel">Fecha Final</td>
				<td nowrap="nowrap" class="fileLabel"><input type="submit" name="bGenerar" value="Generar" onclick="return RangoFechas();"></td>
				<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<cf_conlis
						campos="EdocumentoF"
						desplegables="S"
						modificables="S"
						size="S"
						title="Lista Documentos Contables"
						tabla="EContables a"
						columnas="Edocumento as EdocumentoF
								, Cconcepto as lotefin
								, Eperiodo as periodofin
								, Emes as mesfin
								, Efecha as fechaFin
								, Edescripcion"
						filtro="a.Ecodigo = #Session.Ecodigo# 
								order by a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, a.Edocumento"
						desplegar="lotefin
								, periodofin
								, mesfin
								, fechaFin
								, EdocumentoF
								, Edescripcion"
						filtrar_por="Cconcepto
								, Eperiodo
								, Emes
								, Efecha
								, Edocumento
								, Edescripcion"
						requeridos="S,S,S,N,N,N"
						etiquetas="Concepto, Periodo, Mes, Fecha, Documento, Descripcion"
						formatos="I,I,I,D,I,S"
						align="right,right,right,center,right,left"
						asignar="EdocumentoF
								, lotefin
								, periodofin
								, mesfin
								, fechaFin"
						asignarformatos="I,C,C,C,D"
						MaxRows="20"
						MaxRowsQuery="250"
						form="formfiltro"
						debug="false"
						showEmptyListMsg="true"
						EmptyListMsg="--- No se encontraron documentos contables para los filtros definidos ---"
					/>
				</td>
				<td>
					<select name="lotefin">
						<option value="">Todos</option>
						<cfloop query="rsLotes">
							<option value="#Cconcepto#"<cfif isdefined("form.lotefin") and  form.lotefin eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<select name="periodofin">
						<cfloop query="rsPer">
							<option value="#Eperiodo#" <cfif isdefined("periodo") and  periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<select name="mesfin">
						<cfloop query="rsMeses">
							<option value="#VSvalor#"<cfif isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<cfif isdefined("form.fechaFin")>
						<cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#" form="formfiltro">
					<cfelse>
						<cf_sifcalendario name="fechaFin" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="formfiltro">
					</cfif>
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap="nowrap" class="fileLabel">Formato</td>
				<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
				<td nowrap="nowrap" class="fileLabel">Usuario que Gener&oacute;</td>
				<td nowrap="nowrap" class="fileLabel">Orden</td>
				<td nowrap="nowrap" class="fileLabel">Origen del Asiento</td>
				<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
				<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td nowrap>
					<select name="formato">
						<option value="FlashPaper">FlashPaper</option>
						<option value="pdf">Adobe PDF</option>
						<option value="excel">Microsoft Excel</option>
					</select>
				</td>
				<td>&nbsp;
					
				</td>
				<td>
					<select name="Usuario">
						<cfloop query="rsUsuarios">
							<option value="#rsUsuarios.ECusuario#" >#rsUsuarios.ECusuarioDESC#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<select name="ordenamiento">
						<option value="0" selected>Linea</option>
						<option value="1">Documento</option>
					</select>
				</td>
				<td>
					<input name="origen" type="text" size="5" maxlength="4" value="<cfif isdefined("form.origen")>#form.origen#</cfif>">
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>  
		</table>
	</form>
	<script language="JavaScript"> 
		<!--//
		function RangoFechas(){
			var mesinicial = document.formfiltro.mesini.value;
			var mesfinal = document.formfiltro.mesfin.value;
							 
			var fecha_ini = new Date(parseInt(document.formfiltro.periodoini.value, 10) , parseInt(mesinicial, 10)-1 , parseInt(01, 10));
			var periodo = 0;
			
			var  mes = (parseInt(mesfinal, 10) + 1) % 12;
			if (mes == 1)
			   { periodo = document.formfiltro.periodofin.value + 1;
			} else {
				periodo = document.formfiltro.periodofin.value ;
			}

			fechatemp =  new Date(parseInt(periodo,10), parseInt(mes,10)-1, parseInt(1,10));
			var fecha_fin = new Date(fechatemp.getTime() - 86400000.0);
			
			
			var a = document.formfiltro.fechaIni.value.split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = document.formfiltro.fechaFin.value.split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			
			if (ini < fecha_ini ){
				alert("La fecha inicial no debe ser menor al periodo y mes inicial solicitados.");
				return false;						
			}

			if (fin < fecha_ini ){
				alert("La fecha final  no debe ser menor al periodo y mes inicial solicitados.");
				return false;						
			}
		
			if (ini > fecha_fin ){
				alert("La fecha inicial no debe ser mayor al periodo y mes final solicitados.");
				return false;						
			}
			
			if (fin > fecha_fin ){
				alert("La fecha final no debe ser mayor al periodo y mes final solicitados.");
				return false;						
			}
		}
		//-->
	</script> 
</cfoutput>