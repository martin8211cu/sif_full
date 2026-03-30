<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
	<cfquery name="rsSecuencia" datasource="#Session.DSN#">
		select b.CIEsecuencia
		from PeriodoEvaluacion a, CicloEvaluacion b
		where a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		and a.CIEcodigo = b.CIEcodigo
	</cfquery>
</cfif>

<cfquery name="listaMaterias" datasource="#Session.DSN#">
	select convert(varchar, b.Mcodigo) as Mcodigo, 
		   b.Mcodificacion, 
		   b.Mnombre,
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
			 <cfif form.CILtipoCicloDuracion EQ "E">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			 </cfif>
		   ) as Generados,

		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
			 <cfif form.CILtipoCicloDuracion EQ "E">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			 </cfif>
			 and c.Cestado = 0
		   ) as Inactivos
		   <cfif session.MoG EQ "M">
			,
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
			 <cfif form.CILtipoCicloDuracion EQ "E">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			 </cfif>
			 and c.Cestado = 1
		   ) as Activos,
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
			 <cfif form.CILtipoCicloDuracion EQ "E">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			 </cfif>
			 and c.Cestado = 2
		   ) as Cerrados
		   </cfif>
	from Materia b
	where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
	and MtipoCicloDuracion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CILtipoCicloDuracion#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
	<cfif Form.GAcodigo NEQ "0">
		<cfif Form.GAcodigo NEQ "-1">
			and b.GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">
		<cfelse>
			and b.GAcodigo is null
		</cfif>
	</cfif>
	and b.Mtipo = 'M'
	and b.Mactivo = 1
	<cfif isdefined("form.txtMnombreFiltro") AND trim(form.txtMnombreFiltro) NEQ "">
	and upper(b.Mnombre) like '%#ucase(form.txtMnombreFiltro)#%'
	</cfif>
	
	<!--- Materias en Ciclos con TipoDuracion por Periodo pero con TipoDuración propio de todo el año
		 solo se pueden generar en el primer período --->
	<cfif form.CILtipoCicloDuracion EQ "E" and isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0 and rsSecuencia.CIEsecuencia EQ 1>
		union
		select convert(varchar, b.Mcodigo) as Mcodigo, 
			   b.Mcodificacion, 
			   b.Mnombre,
			   ( select count(1) from Curso c, CursoPeriodo d
				 where c.Mcodigo = b.Mcodigo
				 <cfif Form.Scodigo GT 0>
				 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				 </cfif>
				 and c.Ccodigo = d.Ccodigo
				 and d.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			   ) as Generados,
			   ( select count(1) from Curso c, CursoPeriodo d
				 where c.Mcodigo = b.Mcodigo
				 <cfif Form.Scodigo GT 0>
				 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				 </cfif>
				 and c.Ccodigo = d.Ccodigo
				 and d.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				 and c.Cestado = 0
			   ) as Inactivos
		   <cfif session.MoG EQ "M">
			   ,( select count(1) from Curso c, CursoPeriodo d
				 where c.Mcodigo = b.Mcodigo
				 <cfif Form.Scodigo GT 0>
				 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				 </cfif>
				 and c.Ccodigo = d.Ccodigo
				 and d.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				 and c.Cestado = 1
			   ) as Activos
			   ,( select count(1) from Curso c, CursoPeriodo d
				 where c.Mcodigo = b.Mcodigo
				 <cfif Form.Scodigo GT 0>
				 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				 </cfif>
				 and c.Ccodigo = d.Ccodigo
				 and d.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				 and c.Cestado = 2
			   ) as Cerrados
		   </cfif>
		from Materia b
		where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
		and MtipoCicloDuracion = 'L'
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
		<cfif Form.GAcodigo NEQ "0">
			<cfif Form.GAcodigo NEQ "-1">
				and b.GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">
			<cfelse>
				and b.GAcodigo is null
			</cfif>
		</cfif>
		and b.Mtipo = 'M'
		and b.Mactivo = 1
		<cfif isdefined("form.txtMnombreFiltro") AND trim(form.txtMnombreFiltro) NEQ "">
		and upper(b.Mnombre) like '%#ucase(form.txtMnombreFiltro)#%'
		</cfif>
	</cfif>
	
	order by 2
</cfquery>

<cfif isdefined("listaMaterias") and listaMaterias.recordCount GT 0>
	<cfoutput>
	<form name="frmMaterias" id="frmMaterias" method="post" style="margin: 0;" action="CursoGeneracion_SQL.cfm">
		<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
		<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
		<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
		<cfif form.CILtipoCicloDuracion EQ "E">
		<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
		</cfif>
		<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
		<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
		<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
		<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
		<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
		<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="">
		<input type="hidden" name="Ccodigo" id="Ccodigo" value="">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
		  	<cfif session.MoG EQ "G">
			<td width="5%" nowrap class="tituloListas"><input class="tituloListas" type="checkbox" name="chkAllItems" value="1" onClick="javascript: if (window.funcChkAll) funcChkAll(this);"></td>
			</cfif>
			<td width="10%" nowrap class="tituloListas">Materia</td>
			<td width="30%" nowrap class="tituloListas">&nbsp;</td>
			<cfif session.MoG EQ "G">
			<td width="10%" nowrap class="tituloListas">Cantidad</td>
			<td width="10%" nowrap class="tituloListas">Cupo</td>
			</cfif>
			<td width="5%" nowrap class="tituloListas">Generados</td>
			<cfif session.MoG EQ "G">
			<td width="5%" nowrap class="tituloListas" colspan="2">Inactivos</td>
			<cfelse>
			<td width="5%" nowrap class="tituloListas">Activos</td>
			<td width="5%" nowrap class="tituloListas">Inactivos</td>
			<td width="5%" nowrap class="tituloListas" colspan="2">Cerrados</td>
			</cfif>
		  </tr>
		  <cfloop query="listaMaterias">
		  <tr>
		  	<cfif session.MoG EQ "G">
			<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>"><input type="checkbox" name="chk" value="#Mcodigo#" onClick="javascript: if (window.UpdChkAll) UpdChkAll(this);"></td>
			</cfif>
			<td nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">#listaMaterias.Mcodificacion#</td>
			<td nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">#listaMaterias.Mnombre#</td>
			<cfif session.MoG EQ "G">
			<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				<input type="text" name="Cant_#Mcodigo#" id="Cant_#Mcodigo#" style="text-align: right" size="3" maxlength="2" value="1" onkeyup="javascript: snumber(this,event,0);">
			</td>
			<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				<input type="text" name="Cupo_#Mcodigo#" id="Cupo_#Mcodigo#" style="text-align: right" size="4" maxlength="3" value="0" onkeyup="javascript: snumber(this,event,0);">
			</td>
			</cfif>
			<td align="center" class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				#listaMaterias.Generados#
			</td>
			<cfif session.MoG EQ "G">
			<td align="center"<cfif listaMaterias.Inactivos GT 0>style="color:##FF0000;"</cfif> class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				#listaMaterias.Inactivos#
			</td>
			<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				<cfif listaMaterias.Inactivos GT 0>
					<input type="image" name="btnCursos" src="/cfmx/educ/imagenes/iconos/folder_opn.gif" title="Trabajar con los Cursos Generados Inactivos" onClick="javascript:sbListaCursos(#listaMaterias.Mcodigo#);return false;">
				</cfif>
			</td>
			<cfelse>
			<td align="center"<cfif listaMaterias.Activos GT 0>style="color:##0000FF;"</cfif> class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				#listaMaterias.Activos#
			</td>
			<td align="center" class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				#listaMaterias.Inactivos#
			</td>
			<td align="center" class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				#listaMaterias.Cerrados#
			</td>
			<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
				<cfif listaMaterias.Activos GT 0>
					<input type="image" name="btnCursos" src="/cfmx/educ/imagenes/iconos/folder_opn.gif" title="Trabajar con los Cursos Activos" onClick="javascript:sbListaCursos(#listaMaterias.Mcodigo#);return false;">
				</cfif>
			</td>
			</cfif>
		  </tr>
		  </cfloop>
		  <cfif session.MoG EQ "G">
		  <tr>
			<td colspan="8" align="center">
				<input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" onClick="javascript: return fnGenerar();">
			</td>
		  </tr>
		  </cfif>
		</table>
	</form>
	</cfoutput>
</cfif>
