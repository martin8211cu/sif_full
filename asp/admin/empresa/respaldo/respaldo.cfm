<cfsilent>
	<cfset respaldar = CreateObject("component", "respaldar")>
	<cfset respaldar.datasource = form.Ccache>
	<cfset respaldar.Ecodigo = form.Ereferencia>
	<cfset respaldar.EcodigoSDC = form.emp>
	<cfset respaldar.CEcodigo = form.ctae>
	<cfset respaldar.ruta = respaldar.ruta & form.destsub>	
	<cfset session.stop_backup = false>
	
	<cfif IsDefined('form.respaldar')>
		<cfset title = 'Crear respaldo'>
		<cfset respaldar.preparar_respaldar()>
	<cfelseif IsDefined('form.borrar')>
		<cfset title = 'Borrar datos'>
		<cfset respaldar.preparar_borrar()>
	<cfelseif IsDefined('form.cargar')>
		<cfset title = 'Cargar respaldo'>
		<cfset respaldar.preparar_cargar()>
	<cfelse>
		<cfthrow message="Acción no especificada">
	</cfif>
</cfsilent>
<cf_templateheader title="#title#">
<cfsetting requesttimeout="86400"><!-- máximo de un día, será suficiente? --->
<cfflush interval="512">

<cfquery datasource="asp" name="ctaemp_q">
	select CEnombre
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ctae#">
</cfquery>

<cfquery datasource="asp" name="emp_q">
	select Enombre
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.emp#">
</cfquery>

<cfset thread = CreateObject("java", "java.lang.Thread")>

<cffile action="read" variable="tablas" file="#ExpandPath('/asp/admin/empresa/respaldo/tablas.txt')#">
<cfoutput>
<cf_web_portlet_start titulo="#title#">
<table border="0" cellspacing="0" cellpadding="2" width="807">
  <tr>
    <td colspan="2" class="subTitulo">Parámetros</td>
  </tr>
  <tr>
    <td width="338">Destino</td>
    <td width="461"># HTMLEditFormat( respaldar.ruta )#</td>
  </tr>
  <tr>
    <td>Datasource</td>
    <td># HTMLEditFormat( respaldar.datasource )# 
  <cfif StructKeyExists(application.dsinfo, respaldar.datasource)>
  <cfset DSURL = ListFirst(Application.dsinfo[respaldar.datasource ].url, ';')> 
  <cfif ListLen(DSURL,':') GE 5>
			<cfoutput> (# HTMLEditFormat( REReplace( ListGetAt(DSURL,4,':'), '//', ''))#:#
				HTMLEditFormat( ListGetAt(DSURL,5,':'))#) </cfoutput>
	  </cfif></td>
  </tr></cfif>
  <tr>
    <td>DBServer</td>
    <td># HTMLEditFormat( form.dbserver )#</td>
  </tr>
  <tr>
    <td>Ecodigo</td>
    <td># HTMLEditFormat( respaldar.Ecodigo )#</td>
  </tr>
  <tr>
    <td>CEcodigo</td>
    <td># HTMLEditFormat( respaldar.CEcodigo )#</td>
  </tr>
  <tr>
    <td>Cuenta Empresarial</td>
    <td># HTMLEditFormat( ctaemp_q.CEnombre )#</td>
  </tr>
  <tr>
    <td>Empresa</td>
    <td># HTMLEditFormat( emp_q.Enombre )#</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" class="subTitulo">Estado</td>
    </tr>
  <tr>
    <td>	<cfif IsDefined('form.respaldar')>
				Exportando tabla:
			<cfelseif IsDefined('form.borrar')>
				Borrando tabla:
			<cfelseif IsDefined('form.cargar')>
				Cargando datos de:
			<cfelse>
				<cfthrow message="Acción no especificada">
			</cfif></td>
    <td><div id="tabla">&nbsp;</div></td>
    </tr>
  <tr>
    <td>Avance</td>
    <td><div id="avance" >0 %</div></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><div id="avance0" style="width:200px;background-color:white;border:1px solid black"
		><div id="avance1" style="width:120px;background-color:skyblue;border-right:1px solid gray">&nbsp;</div></div></td>
    </tr>
  <tr>
    <td>Transcurrido</td>
    <td><div id="transcurrido" >&nbsp;</div></td>
  </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td><form action="respaldo-stop.cfm" target="frame01" method="post" name="formTerminar">
	<input type="submit" value="Detener" name="cancelar" class="btnEliminar" />
	<input type="button" value="Continuar" name="continuar" class="btnSiguiente" onclick="btnContinuar()" style="display:none" /></form></td>
    </tr>
</table>
<cf_web_portlet_end>
<iframe name="frame01" width="477" height="100" src="about:blank" frameborder="0"></iframe>

<cfset Total = ListLen(tablas, Chr(13) & Chr(10))>
<script type="text/javascript">
<!--
function $(x){ return document.all?document.all[x]:document.getElementById(x); }
function av (tabla, n, transcurrido) {
	$('tabla').innerHTML = tabla;
	if(n) {
		$('avance1').style.width = Math.floor (n / #Total# * 200) + 'px';
		$('avance').innerHTML = Math.floor (n / #Total# * 100) + ' % (' + n + ' de #Total#)';
	}
	if (isNaN(transcurrido)) {
		$('transcurrido').innerHTML = 'N/D';
	} else if (transcurrido) {
		transcurrido /= 1000;
		$('transcurrido').innerHTML =
			Math.floor(transcurrido / 3600) + ':' +
			Math.floor((transcurrido % 3600) / 60) + ':' +
			Math.floor(transcurrido % 60);
	}
}
function showhide(divid) {
	$(divid).style.display = $(divid).style.display == 'none' ? '' : 'none';
}
function btnContinuar(){
	window.open('../empresas.cfm','_self');
}
//-->
</script>
<cfset n = 0>
<cfset limite = 1000>
<cfset startTime = GetTickCount()>
<cfset tablas = ListToArray(tablas, Chr(13) & Chr(10))>

<cfif IsDefined('form.borrar')>
	<!--- invertir el orden --->
	<cfset tablas2 = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(tablas)#" index="n">
		<cfset tablas2 [n] = tablas [ArrayLen(tablas) - n + 1] >
	</cfloop>
	<cfset tablas = tablas2>
<cfelseif IsDefined('form.respaldar')>
	<cfset ArraySort(tablas, 'textnocase', 'asc')>
</cfif>
<cfset errorcount = 0>

<!--- comienza la iteración --->
<cfif IsDefined('form.borrar')>
	<cfset Resultado = QueryNew('tabla,borrados,quedan,contar,actualizados')>
</cfif>

<cfloop from="1" to="#ArrayLen(tablas)#" index="n">
	<cfset linea = tablas[n]>
	<cfif n GT limite><cfbreak></cfif>
	<cfset tabla = ''>
	<cfif Left(linea,1) neq '##'>
		<!--- Las líneas que comienzan por '#' son comentarios --->
		<cfset campos = ListLen(linea, ':')>
		<cfset modo = ListGetAt(linea, 1, ':')>
		<cfset tabla = ListGetAt(linea, 2, ':')>
		<cfset join = Trim(IIF(campos GE 3, "ListGetAt(linea, 3, ':')", "''"))>
		<cfset anular = Trim(IIF(campos GE 4, "ListGetAt(linea, 4, ':')", "''"))>
		
		<cfset join = ReplaceNoCase(join, 'this.', tabla & '.', 'all')>
		<!--- exportar --->
		<cfif respaldar.tabla_existe(tabla)><cftry>
			<cfif IsDefined('form.respaldar')>
				<cfset respaldar.respaldar_tabla(tabla, join, modo)>
			<cfelseif IsDefined('form.borrar')>
				<cfset actualizados = respaldar.anular_referencias(tabla, join, modo, anular)>
				<cfset borrados = respaldar.borrar_datos(tabla, join, modo, anular)>
				<cfset quedan = respaldar.tiene_datos(tabla, join, modo)>
				<cfif quedan>
					<cfset contar = respaldar.contar_datos(tabla, join, modo)>
				<cfelse>
					<cfset contar = 0>
				</cfif>
				<cfset QueryAddRow(Resultado)>
				<cfset QuerySetCell(Resultado, 'tabla', tabla)>
				<cfset QuerySetCell(Resultado, 'borrados', borrados)>
				<cfset QuerySetCell(Resultado, 'quedan', quedan)>
				<cfset QuerySetCell(Resultado, 'contar', contar)>
				<cfset QuerySetCell(Resultado, 'actualizados', actualizados)>
			<cfelseif IsDefined('form.cargar')>
				<cfset respaldar.cargar_tabla(tabla, join, modo)>
			<cfelse>
				<cfthrow message="Acción no especificada">
			</cfif>
			<cfif session.stop_backup><cfbreak></cfif>
		<cfcatch type="any">
			<cfset errorcount = errorcount + 1>
			<div style="background-color:##cccccc; color: red; padding:4px; margin-bottom:4px" onclick="showhide('divsql#errorcount#')">
				<div style="background-color:pink;font-weight:bold">#errorcount#. Tabla: #tabla#</div>
				#cfcatch.Message# #cfcatch.Detail#
				<cfif IsDefined('cfcatch.SQL')><div style="color:black;display:none" id="divsql#errorcount#">
				#
				REReplace(
				REReplace( cfcatch.SQL,
					'\t+|(set rowcount \d+)|(select @@rowcount as cant)', '','all'),
					'[\t\n\r]+', '<br>','all')#</div>
				</cfif>
			</div>
		</cfcatch>
		</cftry></cfif>
	
		<!--- una pausa para el flush --->
		#RepeatString(' ', 512)#
		<cfset thread.sleep(10)>
	</cfif>
	<script type="text/javascript">
	<!--
		av('#JSStringFormat(tabla)#', '#n#', '#JSStringFormat( GetTickCount() - startTime )#');
	//-->
	</script>
</cfloop>
<script type="text/javascript">
<!--
	document.formTerminar.cancelar.style.display = 'none';
	document.formTerminar.continuar.style.display = '';
//-->
</script>
<cfif IsDefined('form.respaldar')>
	<cfset respaldar.terminar_respaldo()>
<cfelseif IsDefined('form.borrar')>
	<cfset respaldar.terminar_borrado()>
<cfelseif IsDefined('form.cargar')>
	<cfset respaldar.terminar_carga()>
<cfelse>
	<cfthrow message="Acción no especificada">
</cfif>



<script type="text/javascript">
<!--
<cfif session.stop_backup>
av('<strong>Detenido por el usuario</strong>', 0, '#JSStringFormat( GetTickCount() - startTime )#');
<h2>Detenido por el usuario</h2>
<cfelseif n GT limite>
av('<strong>L&iacute;mite de tablas (#limite#) alcanzado</strong>', 0, '#JSStringFormat( GetTickCount() - startTime )#');
<cfelse>
av('<strong>Completado</strong>', 0, '#JSStringFormat( GetTickCount() - startTime )#');
</cfif>
//-->
</script>

</cfoutput>
<cfif IsDefined('form.respaldar')>
	<cfset respaldar.guardar_info('Respaldo realizado #Now()#')>
<cfelseif IsDefined('form.borrar')>
	<cfquery dbtype="query" name="Resultado">
		select * from Resultado order by tabla
	</cfquery>
	<cfquery dbtype="query" name="total">
		select sum(contar) as sum_contar, sum(borrados) as sum_borrados
		from Resultado</cfquery>
	<table style="border:1px solid black"><tr class="tituloListas"><td><em><strong>Contar</strong></em></td>
	<td><em><strong>Borrados</strong></em></td>
	</tr>
	<cfoutput query="Total">
	<tr><td>#sum_contar#</td><td>#sum_borrados#</td></tr>
	</cfoutput></table>
	<table style="border:1px solid black" border="1"><tr class="tituloListas"><td><em><strong>Tabla</strong></em></td>
	<td><em><strong>Quedan</strong></em></td>
	<td><em><strong>Contar</strong></em></td>
	<td><em><strong>Borrados</strong></em></td>
	<td><em><strong>Depende de</strong></em></td>
	</tr>
	<cfoutput query="Resultado"><cfif Borrados Or Quedan Or True>
	<tr id="trinfo#HTMLEditFormat(Tabla)#" class="listaPar">
		<td valign="top"><cfif Borrados><strong>#Tabla#</strong><cfelse>#Tabla#</cfif></td><td>#YesNoFormat(Quedan)#</td>
		<td valign="top"><cfif Contar NEQ 0>#Contar#<cfelse>&nbsp;</cfif></td>
		<td valign="top"><cfif Borrados NEQ 0>#Borrados#<cfelse>&nbsp;</cfif></td>
		<td valign="top"><cfif Contar NEQ 0>
			<cfset tablas_hijas = respaldar.QueryAncestros(tabla, -1)>
			<cfloop query="tablas_hijas">
				<cfquery dbtype="query" name="registros">
					select * from Resultado
					where tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#table1#">
				</cfquery>
				<cfif registros.RecordCount is 0 or registros.contar gt 0>
				<span onmouseover="this.style.backgroundColor='skyblue';x=$('trinfo#HTMLEditFormat(table1)#');if(x)x.className='listaParSel'"
					onmouseout="this.style.backgroundColor='';x=$('trinfo#HTMLEditFormat(table1)#');if(x)x.className='listaPar'">
				<cfif registros.RecordCount is 0>
					#HTMLEditFormat( table1 )# (externa)
				<cfelseif registros.contar gt 0>
					#HTMLEditFormat( table1 )# (#registros.contar#)
				</cfif>
				</span></cfif>
			</cfloop>
		<cfelse>&nbsp;</cfif></td></tr>
	</cfif></cfoutput></table>
</cfif>

<cf_templatefooter>