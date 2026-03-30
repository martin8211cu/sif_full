<!--- Consultas --->
<!--- 1. Sistemas --->
<cfquery name="sistemas" dataSource="asp">
	select rtrim(SScodigo) as SScodigo, SSdescripcion
	from SSistemas
	order by 1
</cfquery>

<!--- 2. Modulos --->
<cfquery name="modulos" dataSource="asp">
	select rtrim(m.SScodigo) as SScodigo, rtrim(m.SMcodigo) as SMcodigo, m.SMdescripcion, s.SSdescripcion
	from SModulos m, SSistemas s
	where s.SScodigo = m.SScodigo
	order by 1, 2
</cfquery>

<!--- 4. roles --->
<cfquery name="roles" dataSource="asp">
	select b.SScodigo,a.SSdescripcion as Sistema,b.SRcodigo as SRcodigo,b.SRdescripcion
	from SSistemas a,SRoles b
</cfquery>

<!--- JavaScripts --->
<script type="text/javascript">
function preparar(f) {
	if (f.tipo[0].checked || f.tipo[1].checked) {
		return true;
	} else {
		return false;
	}
}
</script>


<table width="45%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="6%" nowrap><div align="center"></div></td>
    <td width="94%" colspan="2" nowrap>&nbsp;</td>
  </tr>

  <form action="exportar-apply.cfm" method="post" name="form1">
	  <tr>
		<td nowrap colspan="3" class="itemtit"><div align="center">&nbsp;Seleccione el tipo de exportación que desea realizar:</div></td>
	  </tr>
	  <tr>
		<td align="center" nowrap>		  <input name="rango" id="rango_t" type="radio" value="t" checked>	    </td>
		<td colspan="2" nowrap><label for="rango_t">Exportar todo</label></td>
	  </tr>
	  <tr><td>&nbsp;</td></tr>
	  <tr>
		<td align="center" nowrap>		  <input type="radio" id="rango_s" name="rango" value="s">	    </td>
		<td colspan="2" nowrap><label for="rango_s">Exportar un sistema espec&iacute;fico</label></td>
	  </tr>
	  <tr>
		<td align="center" nowrap><div align="center"></div></td>
		<td colspan="2" nowrap>
			<select name="SScodigo" id="SScodigo" onChange="javascript:form1.rango[1].checked=true" onclick="javascript:form1.rango[1].checked=true">
				<cfoutput query="sistemas">
					<option value="#SScodigo#">#SScodigo# - #SSdescripcion#</option>
				</cfoutput>
    	    </select>
		</td>
	  </tr>
  	  <tr><td>&nbsp;</td></tr>
	  <tr>
		<td align="center" nowrap>		  <input type="radio" id="rango_m" name="rango" value="m">	    </td>
		<td colspan="2" nowrap><label for="rango_m">Exportar un m&oacute;dulo espec&iacute;fico</label></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center"></div></td>
		<td colspan="2" nowrap>
			<select name="SMcodigo" id="SMcodigo" onChange="javascript:form1.rango[2].checked=true" onclick="javascript:form1.rango[2].checked=true">
				<cfoutput query="modulos">
					<option value="#SScodigo#,#SMcodigo#">#SScodigo# #SMcodigo# - #SMdescripcion#</option>
				</cfoutput>
			</select>
		</td>
	  </tr>
  	  <tr><td>&nbsp;</td></tr>
	  <tr>
		<td align="center" nowrap>		  <input type="radio" id="rango_p" name="rango" value="p">	    </td>
		<td colspan="2" nowrap><label for="rango_s">Exportar un proceso espec&iacute;fico</label></td>
	  </tr>
      <tr>
		<td align="center" nowrap><div align="center"></div></td>
		<td colspan="2" nowrap>
			<cf_conlis title="Lista de Procesos"
				campos = "SScodigo_P , SMcodigo_P, SPcodigo_P,SSdescripcion,SMdescripcion,SPdescripcion"
				desplegables = "N,N,S,N,N,S"
				modificables = "N,N,S,N,N,N"
				size = "0,0,0,0,0,0"
				tabla="SProcesos p, SModulos m, SSistemas s"
				columnas="rtrim(p.SScodigo) as SScodigo_P,
						  rtrim(p.SMcodigo) as SMcodigo_P,
						  rtrim(p.SPcodigo) as SPcodigo_P,
						  s.SSdescripcion,
						  m.SMdescripcion,
						  p.SPdescripcion,
						  3 rango"
				filtro="p.SMcodigo = m.SMcodigo
					  and p.SScodigo = m.SScodigo
					  and m.SScodigo = s.SScodigo
						order by 1, 2, 3"
				desplegar="SMdescripcion,SPdescripcion"
				etiquetas="Modulo, Proceso"
				formatos="S,S,S"
				align="left,left,left"
				asignar="SScodigo_P,SMcodigo_P,SPcodigo_P,SPdescripcion"
				asignarformatos="S,S,S"
				showEmptyListMsg="true"
				debug="false"
				tabindex="1"
				cortes="SSdescripcion"
				conexion="asp"
				funcion="MarcarRango"
				fparams="rango">
		</td>
	  </tr>
  	  <tr><td>&nbsp;</td></tr>
	  <!---Exportación de roles--->
	  <tr>
		<td align="center" nowrap>		  <input type="radio" id="rango_m" name="rango" value="r">	    </td>
		<td colspan="2" nowrap><label for="rango_m">Exportar un rol espec&iacute;fico</label></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center"></div></td>
		<td colspan="2" nowrap>
			<select name="SMrol" id="SMrol" onChange="javascript:form1.rango[4].checked=true" onclick="javascript:form1.rango[4].checked=true">
				<cfoutput query="roles">
					<option value="#SScodigo#,#SRcodigo#,#SRdescripcion#">#SScodigo# - #SRcodigo# - #SRdescripcion#</option>
				</cfoutput>
			</select>
		</td>
	  </tr>
	  <!------>
	  <tr><td>&nbsp;</td></tr>
	  <tr>
		  <td align="center"><input name="politica" type="checkbox" id="politica" value="1" checked></td>
          <td colspan="2"><label for="politica">Exportar nuevas pol&iacute;ticas del portal </label></td>
   	 </tr>
	 <tr>
		  <td align="center"><input name="proceso" type="checkbox" id="proceso" value="1" checked></td>
          <td colspan="2"><label >Exportar Definición de Roles </label></td>
   	 </tr>
		<tr><td colspan="3">&nbsp;</td></tr>
  	  <tr>
		<td nowrap colspan="3" class="itemtit"><div align="left">&nbsp;Seleccione el formato del archivo exportado:</div></td>
	  </tr>
	  <tr>
		<td align="center" nowrap>		  <input name="tipo" type="radio" value="xml">	    </td>
		<td colspan="2" nowrap><a href="#" onClick="javascript:form1.tipo[0].checked=true">xml</a></td>
	  </tr>
	  <tr>
		<td align="center" nowrap>		  <input type="radio" name="tipo" value="sql" checked>	    </td>
		<td colspan="2" nowrap><a href="#" onClick="javascript:form1.tipo[1].checked=true">sql</a>
		para <cfparam name="url.dbms" default="#Left(Application.dsinfo.asp.type,3)#">
		<select name="dbms" id="dbms">
	      <option value="syb" <cfif url.dbms is 'syb'>selected</cfif>>Sybase</option>
	      <option value="ora" <cfif url.dbms is 'ora'>selected</cfif>>Oracle</option>
	      <option value="db2" <cfif url.dbms is 'db2'>selected</cfif>>DB2</option>
	      <option value="mss" <cfif url.dbms is 'mss'>selected</cfif>>MS SQL Server</option>
        </select>
		</td>
	  </tr>
	  <tr>
	    <td align="center" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><input type="checkbox" id="insertonly" name="insertonly"></td>
        <td valign="top" nowrap><label for="insertonly">
Generar solamente inserts <br>
Requiere que la base de datos destino est&eacute; vac&iacute;a.</label></td>
    </tr>
	  <tr>
	    <td nowrap>&nbsp;</td>
	    <td colspan="2" nowrap>&nbsp;</td>
    </tr>
	<cfif session.dsinfo.type neq 'sybase'>
	  <tr>
	    <td nowrap>&nbsp;</td>
	    <td colspan="2" ><div style="color: #FF0000;font-size:14px"><strong>Error: </strong>Se ha detectado que est&aacute; usando este programa en una base de datos que no es Sybase.</div>
	      Esta exportaci&oacute;n deber&iacute;a realizarse <strong>siempre</strong> desde una base de datos en Sybase, que es case-sensitive. Si realiza la exportaci&oacute;n desde aqu&iacute;, no podr&aacute; utilizarla en Sybase case-sensitive.
		  </td>
    </tr>
	</cfif>
	  <tr>
	    <td nowrap>&nbsp;</td>
		<td colspan="2" nowrap>
		    <div align="center">
		     <input name="exportar" type="submit" id="exportar" value="Exportar">
	        </div>
		</td>
	  </tr>
  </form>
  <tr>
    <td nowrap><div align="center"></div></td>
    <td colspan="2" nowrap>&nbsp;</td>
  </tr>
</table>
<script type="text/javascript">
	function MarcarRango(rango) {
		document.form1.rango[rango].checked=true;
	}
</script>