<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfoutput>
<form name="form_ctas">
	<table width="100%" align="center">
		<tr>
			<td width="33%" nowrap>
				<strong>Grupo de Objeto de Gasto:</strong>
			</td>
			<cfquery datasource="#session.dsn#" name="rsOBG">
				select OBGid, OBGcodigo, OBGdescripcion
				  from OBobra o
				  	inner join OBgrupoOG og
						on og.PCEcatidOG = o.PCEcatidOG
				 where o.OBOid = #form.OBOid#
			</cfquery>
			<td width="33%">
				<select name="OBGid" id="OBGid" onchange="sbGOGid_change(this);">
					<option value="">(Agregar Cuentas Individuales)</option>
				<cfloop query="rsOBG">
					<option value="#rsOBG.OBGid#">#rsOBG.OBGcodigo# - #rsOBG.OBGdescripcion#</option>
				</cfloop>
				</select>
			</td>
		</tr>

		<tr>
			<td width="33%" nowrap colspan="1">
				<strong>Nueva Cuenta Financiera:</strong>
			</td>
			<td width="33%" align="right" nowrap="nowrap">
				<input type="button" value="Agregar" id="btnAltaCta"
					 onclick="
						var LvarCFformato = fnCFformatoCompleto(true);
						if (LvarCFformato != '')
						 	location.href = 'OBetapa_sql.cfm?btnAltaCta=1&OBOid=#form.OBOid#&OBEid=#form.OBEid#&CFformato=' + LvarCFformato;
					 " 
				/>
				<input type="button" value="Agregar Masivo" id="btnAltaMasivo"
					 onclick="return fnAltaMasivo()"
					 <cfif rsOBG.recordCount EQ 0>disabled</cfif>
					 style="display:none;"
				/>
			</td>
			<td width="33%">&nbsp;</td>
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="4">
				<cf_cuentaObra name="CFformatoEta" OBOid="#form.OBOid#" onEnter="document.getElementById('btnAltaCta').click();">
			</td>
			<td>&nbsp;</td>
		</tr>	
	</table>
</form>
</cfoutput>

<cfquery datasource="#session.dsn#" name="rsStatus">
	select -1 as value, ' ' as description from dual
	UNION
	select 0 as value, 'Nueva' as description from dual
	UNION
	select 1 as value, 'Activa' as description from dual
	UNION
	select 2 as value, 'Inactiva' as description from dual
	UNION
	select 3 as value, 'Con Error' as description from dual
	order by value
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	columnas=
		"
		e.OBEid,
		case OBEestado
			when '1' then
				case OBECestado 
					when '0' then
						'<img src=""../../imagenes/Borrar01_S.gif""  style=""cursor:pointer;"" title=""BORRAR"" onclick=""location.href = ''OBetapa_sql.cfm?btnBajaCta=1&OBOid=#url.OBOid#&OBEid=#url.OBEid#&CFformato=' #_CAT# a.CFformato #_CAT# ''';"" width=""20""/>'
					when '1' then
						'<img src=""../../imagenes/checked.gif"" style=""cursor:pointer;"" title=""INACTIVAR"" onclick=""location.href = ''OBetapa_sql.cfm?btnBajaCta=1&OBOid=#url.OBOid#&OBEid=#url.OBEid#&CFformato=' #_CAT# a.CFformato #_CAT# ''';""/>'
					when '2' then
						case when OBECmsgGeneracion is not null then
							'<img src=""../../imagenes/unchecked.gif""/>'
						else
							'<img src=""../../imagenes/unchecked.gif""  style=""cursor:pointer;"" title=""ACTIVAR"" onclick=""location.href = ''OBetapa_sql.cfm?btnActivarCta=1&OBOid=#url.OBOid#&OBEid=#url.OBEid#&CFformato=' #_CAT# a.CFformato #_CAT# ''';""/>'
						end
				end
			else '<img src=""../../imagenes/lock.gif"">'
		end as OP
	  ,	case 
	  		when OBECmsgGeneracion is not null then
				'<img src=""../../imagenes/TBP_0092.JPG""  style=""cursor:pointer;"" title=""Error de Generación"" onclick=''alert(""ERROR GENERACION: ' #_CAT# a.OBECmsgGeneracion #_CAT# '"");''/>'
			else case OBECestado 
				when '0' then
					'Nueva'
				when '1' then
					case OBEestado
						when '1' then
							'Activa'
						else
							'Bloqueada'
					end
				when '2' then
					'Inactiva'
			end
		end as Status
	 ,	a.CFformato
		"
	tabla = 
		"
		OBetapaCuentas a
			inner join OBetapa e
				on e.OBEid = a.OBEid
		"
	filtro=
		"
			a.OBEid = #form.OBEid#
		"
	formname="lista_ctas"
	desplegar="OP, Status, CFformato"
	etiquetas=" , Estado, Cuenta Financiera"
	formatos="U,S,S"
	align="center,center,left"
	ira="OBetapa.cfm"
	form_method="post"

	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_Por=" ,case when OBECmsgGeneracion is not null then '3' else OBECestado end,CFformato"
	rsStatus="#rsStatus#"

	showlink="no"
	pageIndex="2"
/>
<cfoutput>
<script>
	function funcFiltrar2()
	{
		document.lista_ctas.OBEID.value = "#form.OBEid#";
		return true;
	}
	
	function fnAltaMasivo()
	{
		var LvarGrupo = document.getElementById("OBGid");
		LvarGrupo = LvarGrupo.options[LvarGrupo.selectedIndex].text;
		var LvarCFformato = fnCFformatoCompleto(true);
		if (LvarCFformato != '')
			if (confirm("INCLUSION MASIVA POR GRUPO DE OBJETOS DE GASTO:\n\n¿Desea agregar todas las cuentas nuevas\n\t" + LvarCFformato + "\n\npara el Grupo de Objetos de Gasto:\n\t" + LvarGrupo +"?"))
				location.href = "OBetapa_sql.cfm?btnAltaMasivo=1&OBOid=#form.OBOid#&OBEid=#form.OBEid#&OBGid=" + document.getElementById("OBGid").value + "&CFformato=" + LvarCFformato;
	}
</script>
</cfoutput>
