<cfset LvarFuncion1 = "aftfDispositivosMoviles">

<!---filtro--->
<cfset filtro = "a.CEcodigo = #session.CEcodigo# and a.Ecodigo = #session.Ecodigo#">

<cfif isdefined('form.filtro_AFTFdescripcion_hoja') and len(trim(form.filtro_AFTFdescripcion_hoja))>
	<cfset filtro = filtro & " and upper(AFTFdescripcion_hoja) like '%#Ucase(Form.filtro_AFTFdescripcion_hoja)#%'">
</cfif>

<cfif isdefined('form.filtro_AFTFestatus_hoja') and len(trim(form.filtro_AFTFestatus_hoja)) and #form.filtro_AFTFestatus_hoja# neq -1>
	<cfset filtro = filtro & " and (case a.AFTFestatus_hoja
				when 0 then '0'
				when 1 then '1'
				when 2 then '2'
				when 3 then '3'
				when 9 then '9'
			end) = #form.filtro_AFTFestatus_hoja#">
</cfif>	


<cfoutput>
<script language="javascript" type="text/javascript">
	var popUpWin#LvarFuncion1#=null;
	function popUpWindow#LvarFuncion1#(URLStr, left, top, width, height)
	{
	  if(popUpWin#LvarFuncion1#)
	  {
		if(!popUpWin#LvarFuncion1#.closed) popUpWin#LvarFuncion1#.close();
	  }
	  popUpWin#LvarFuncion1# = open(URLStr, 'popUpWin#LvarFuncion1#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	  if (! popUpWin#LvarFuncion1# && !document.popupblockerwarning) {
		alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
		document.popupblockerwarning = 1;
	  }
	}
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0px" class="tituloListas">
  <tr>
    <td align="right"><a href="##" onclick="javascript:popUpWindow#LvarFuncion1#(('aftfHojasCoteo-rpt.cfm'),50,50,600,400);">Imprimir</a> <a href="##" onclick="javascript:popUpWindow#LvarFuncion1#(('aftfHojasCoteo-rpt.cfm'),50,50,600,400);"><img src="/cfmx/sif/imagenes/impresora.gif" border="0"></a></td>
  </tr>
</table>
</cfoutput>

	<cfquery name="rsEstados" datasource="#session.DSN#">
		select  <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as value, 'Todos' as description from dual
		union all
		select  0 as value, 'En Generación de Hoja' as description from dual
		union all
		select 1 as value, 'En Disposotivo Móvil' as description from dual
		union all
		select 2 as value, 'En Proceso de Inventario' as description from dual
		union all
		select 3 as value, 'Aplicada' as description from dual
		union all
		select 4 as value, 'Cancelada' as description from dual
		order by 1
	</cfquery>
	
	<cfquery name="Lista" datasource="#session.dsn#">
		select 
			a.AFTFid_hoja, a.AFTFdescripcion_hoja, a.AFTFfecha_hoja, a.AFTFfecha_conteo_hoja, 
			case a.AFTFestatus_hoja
				when 0 then 'En Generación de Hoja'
				when 1 then 'En Disposotivo Móvil'
				when 2 then 'En Proceso de Inventario'
				when 3 then 'Aplicada'
				when 9 then 'Cancelada'
			end as AFTFestatus_hoja,
			
			case a.AFTFestatus_hoja
				when 0 then null
				else a.AFTFid_hoja
			end as AFTFinactivar_checkbox,
			
			'' as AFTFespacio_en_blanco		
		from AFTFHojaConteo a
			inner join DatosEmpleado b on
				a.DEid = b.DEid
		where #preservesinglequotes(filtro)#
		
		<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores)) and isdefined('form.filtro_AFTFfecha_hoja') and len(trim(form.filtro_AFTFfecha_hoja))>
		 and <cf_dbfunction name="to_date00" args="AFTFfecha_hoja"> >=  <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#form.filtro_AFTFfecha_hoja#">
		</cfif>
		<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores)) and isdefined('form.filtro_AFTFfecha_conteo_hoja') and len(trim(form.filtro_AFTFfecha_conteo_hoja))>
		 and <cf_dbfunction name="to_date00" args="AFTFfecha_conteo_hoja"> >=  <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#form.filtro_AFTFfecha_conteo_hoja#">
		</cfif>
		<cfif isdefined('form.filtro_AFTFfecha_hoja') and len(trim(form.filtro_AFTFfecha_hoja))>
		 and <cf_dbfunction name="to_date00" args="AFTFfecha_hoja"> =  <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#form.filtro_AFTFfecha_hoja#">
		</cfif>
		<cfif isdefined('form.filtro_AFTFfecha_conteo_hoja') and len(trim(form.filtro_AFTFfecha_conteo_hoja))>
		 and <cf_dbfunction name="to_date00" args="AFTFfecha_conteo_hoja"> =  <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#form.filtro_AFTFfecha_conteo_hoja#">
		</cfif>
		order by AFTFfecha_hoja desc
</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#Lista#"
	desplegar="AFTFdescripcion_hoja, AFTFfecha_hoja, AFTFfecha_conteo_hoja, AFTFestatus_hoja, AFTFespacio_en_blanco"
	etiquetas="Descripci&oacute;n, Fecha, Fecha Cierre, Condici&oacute;n, "
	formatos="S, D, D, S, U"
	align="left, center, center, left, right"
	ajustar="N, N, N, N, N"
	irA="aftfHojasCoteo.cfm"
	checkboxes="S"
	botones="Nuevo, Eliminar"
	keys="AFTFid_hoja"
	mostrar_filtro="true"
	filtrar_automatico="true"
	filtrar_por="a.AFTFdescripcion_hoja, a.AFTFfecha_hoja, a.AFTFfecha_conteo_hoja, 
			 a.AFTFestatus_hoja, ''"
	rsAFTFestatus_hoja="#rsEstados#"
	inactivecol="AFTFinactivar_checkbox"
	maxrows="15"
/>
<script language="javascript" type="text/javascript">
	<!--//
	/*Funciones de Activar e Inactivar de la Lista*/
	function funcEliminar(){
		if (fnAlgunoMarcadolista()){
			if (confirm("¿Está seguro de que desea Eliminar las Hojas de Conteo seleccionadas?")) {
				document.lista.action = "aftfHojasCoteo-sql.cfm";
				return true;
			}
		} else {
			alert('Debe seleccionar una Hoja de Conteo a Eliminar!');
		}		
		return false;
	}
	//-->
</script>