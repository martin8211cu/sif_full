<cfquery name="rsTiposRep" datasource="#Session.DSN#">
    select ID_Estr,EPcodigo, EPdescripcion
    from CGEstrProg
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
</cfquery>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and a.ID_Estr = " & Form.fID_Estr>
</cfif>

<cfif isdefined("Form.fCmayor") and Len(Trim(Form.fCmayor))>
	<cfset filtro = filtro & " and a.CGEPCtaMayor = '" & Form.fCmayor & "'">
</cfif>
<cfif isdefined("Form.fCtipo") and Len(Trim(Form.fCtipo))>
	<cfset filtro = filtro & " and a.CGEPctaTipo = '" & Form.fCtipo & "'">
</cfif>

<cfif isdefined("Form.fCsubtipo") and Len(Trim(Form.fCsubtipo))>
	<cfset filtro = filtro & " and a.CGEPctaGrupo = " & Form.fCsubtipo>
</cfif>

<cfif isdefined("Form.FCGARCTABALANCE") and Len(Trim(Form.FCGARCTABALANCE))>
	<cfset filtro = filtro & " and a.CGEPctaBalance = " & Form.FCGARCTABALANCE>
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Lista de Cuentas por Tipo de Reporte</strong>
		</td>
      </tr>
	  <tr>
		<td>
			<cfset campos = "">
			<form name="filtroCM" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
				<input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">
				<input name="tab" type="hidden" value="2">
				<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
				  <tr>
					<td nowrap style="background-color:##CCCCCC"><strong>Cta Mayor</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Tipo</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Subtipo</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Balance</strong></td>
					<td nowrap style="background-color:##CCCCCC">&nbsp;</td>
				  </tr>
				  <tr>
					<td>
						<input type="text" name="fCmayor" size="10" tabindex="2" maxlength="4" value="<cfif isdefined("Form.fCmayor")><cfset campos = campos & "'" & #Form.fCmayor# & "' as fCmayor,">#Form.fCmayor#</cfif>"/>
					</td>
					<td>
					  <select name="fCtipo" id="fCtipo" onChange="javascript: changeTipo(this);" tabindex="2">
						<option value="">Todos</option>
						<option value="A" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "A"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Activo</option>
						<option value="P" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "P"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Pasivo</option>
						<option value="C" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "C"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Capital</option>
						<option value="I" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "I"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Ingreso</option>
						<option value="G" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "G"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Gasto</option>
						<option value="O" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "O"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Orden</option>
					  </select>
					</td>
					<td>
					  <select name="fCsubtipo" id="fCsubtipo" tabindex="2">
						<option value="">Todos</option>
						<option value="1" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "1"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Ventas o Ingresos</option>
						<option value="2" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "2"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Costos de Operaci&oacute;n</option>
						<option value="3" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "3"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Gastos de Operaci&oacute;n y Administrativos</option>
						<option value="4" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "4"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Otros Ingresos Gravables</option>
						<option value="5" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "5"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Otros Gastos Deducibles</option>
						<option value="6" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "6"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Ingresos no Gravables</option>
						<option value="7" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "7"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Gastos no Deducibles</option>
						<option value="8" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "8"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Impuestos</option>
					  </select>
					</td>
					<td>
						<select name="fCGARctaBalance" tabindex="2">
							<option value="">Todos</option>
							<option value="1" <cfif isdefined("Form.fCGEPctaBalance") and Form.fCGEPctaBalance EQ "1"><cfset campos = campos & #Form.fCGEPctaBalance# & " as fCGARctaBalance,"> selected</cfif>>D&eacute;bito</option>
							<option value="-1" <cfif isdefined("Form.fCGEPctaBalance") and Form.fCGEPctaBalance EQ "-1"><cfset campos = campos & #Form.fCGEPctaBalance# & " as fCGARctaBalance,"> selected</cfif>>Cr&eacute;dito</option>
						</select>
					</td>

					<td>
						<input type="submit" name="btnFiltrar" value="Filtrar" tabindex="2">
					</td>
				  </tr>
				</table>
			</form>
		</td>
	  </tr>
	  <tr>
		<td valign="top">

			<cfif len(campos) gt 0>
				<cfif mid(trim(campos),len(trim(campos)),1) eq "," >
					<cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
				<cfelse>
					<cfset campos = "," & campos & " ">
				</cfif>
			</cfif>
			<cfset params = '?tab=2'>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"

				columnas="	a.ID_EstrCta,
                			a.ID_Estr,
                            a.ID_Grupo,
							a.CGEPCtaMayor,
							c.EPGcodigo,
							case
							when a.CGEPctaTipo = 'A' then 'Activo'
							when a.CGEPctaTipo = 'P' then 'Pasivo'
							when a.CGEPctaTipo = 'C' then 'Capital'
							when a.CGEPctaTipo = 'I' then 'Ingreso'
							when a.CGEPctaTipo = 'G' then 'Gasto'
							when a.CGEPctaTipo = 'O' then 'Orden'
							else ''
							end as Tipo,
							case
							when a.CGEPctaGrupo = 1 then 'Ventas o Ingresos'
							when a.CGEPctaGrupo = 2 then 'Costos de Operaci&oacute;n'
							when a.CGEPctaGrupo = 3 then 'Gastos de Operaci&oacute;n y Administrativos'
							when a.CGEPctaGrupo = 4 then 'Otros Ingresos Gravables'
							when a.CGEPctaGrupo = 5 then 'Otros Gastos Deducibles'
							when a.CGEPctaGrupo = 6 then 'Ingresos no Gravables'
							when a.CGEPctaGrupo = 7 then 'Gastos no Deducibles'
							when a.CGEPctaGrupo = 8 then 'Impuestos'
							else ''
							end as Subtipo,
                            CGEPDescrip, CGEPInclCtas,
							InclCtas = case CGEPInclCtas when 1 then 'Incluir Todas' when 2 then 'Incluir Lista' when 3 then 'Excluir Lista' end,
                            a.CGEPctaBalance,
							case when a.CGEPctaBalance = 1 then 'D&eacute;bito' else 'Cr&eacute;dito' end as Balance #campos#"
				tabla="CGEstrProgCtaM a
						inner join CGEstrProg b
							on b.ID_Estr = a.ID_Estr
						left join CGGrupoCtasMayor c
							on c.ID_Grupo = a.ID_Grupo "
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by a.CGEPCtaMayor, a.CGEPctaTipo, a.CGEPctaGrupo, a.CGEPctaBalance"
				desplegar="CGEPCtaMayor, Tipo, Subtipo, Balance, EPGcodigo, InclCtas"
				etiquetas="Cuenta Mayor, Tipo, Subtipo, Balance, Grupo, Inc/Exc"
				formatos="S,S,S,S,S, S"
				align="left, left, left, left, left, left"
				checkboxes="N"
				ira="CuentasEstrProg.cfm#params#"
				nuevo="CuentasEstrProg.cfm#params#"
				showLink="true"
				showemptylistmsg="true"
				keys="ID_Estr, CGEPCtaMayor"
				mostrar_filtro="false"
				filtrar_automatico="true"
				maxrows="15"
				navegacion="#navegacion#&tab=2"
				/>

		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>

