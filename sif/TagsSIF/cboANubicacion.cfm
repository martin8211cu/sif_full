<cfparam name="Attributes.Ecodigo" 	default="#Session.Ecodigo#" type="String">
<cfparam name="Attributes.Ocodigo" 	default="-1" 	type="String">
<cfparam name="Attributes.GEid" 	default="-1" 	type="String">
<cfparam name="Attributes.GOid" 	default="-1" 	type="String">
<cfparam name="Attributes.GODid" 	default="-1" 	type="String">
<cfparam name="Attributes.Modo" 	default="ALTA"	type="String">
<cfparam name="Attributes.Tipo" 	default=""		type="String">
<cfparam name="Attributes.Propio" 	default="no"	type="boolean">

<cfif Attributes.Tipo NEQ "CONSULTA" AND Attributes.Tipo NEQ "DISEÑO" AND Attributes.Tipo NEQ "CALCULO" AND Attributes.Tipo NEQ "CALCULOCELDA">
	<cf_errorCode	code = "50586" msg = "Falta indicar Attributes.Tipo = 'CONSULTA' o 'DISEÑO' o 'CALCULO' o 'CALCULOCELDA'">
</cfif>
<cfif Attributes.Modo EQ "ALTA">
	<cfset LvarANubicaTipo = "">
<cfelseif Attributes.GODid NEQ "-1" AND Attributes.GODid NEQ "">
	<cfset LvarANubicaTipo = "GOD">
<cfelseif Attributes.GEid NEQ "-1" AND Attributes.GEid NEQ "">
	<cfset LvarANubicaTipo = "GE">
<cfelseif Attributes.GOid NEQ "-1" AND Attributes.GOid NEQ "">
	<cfset LvarANubicaTipo = "GO">
<cfelseif Attributes.Ocodigo NEQ "-1" AND Attributes.Ocodigo NEQ "">
	<cfset LvarANubicaTipo = "O">
<cfelseif Attributes.Ecodigo NEQ "-1" AND Attributes.Ecodigo NEQ "">
	<cfset LvarANubicaTipo = "E">
<cfelse>
	<cfif Attributes.Tipo EQ "DISEÑO" OR Attributes.Tipo EQ "CONSULTA">
		<cfset LvarANubicaTipo = "">
	<cfelse>
		<cfset LvarANubicaTipo = "E">
	</cfif>
</cfif>

<cfif Attributes.tipo EQ "CONSULTA">
	<cfoutput>
	<input type="hidden" name="ANubicaTipo" 	value="#LvarANubicaTipo#">
	<cfif LvarANubicaTipo EQ "">
		<strong>Se determina en Cálculo</strong>
		<input type="hidden" name="ANubicaEcodigo" 	value="-1">
		<input type="hidden" name="ANubicaOcodigo" 	value="-1">
		<input type="hidden" name="ANubicaGOid" 	value="-1">
		<input type="hidden" name="ANubicaGEid" 	value="-1">
	<cfelseif LvarANubicaTipo EQ "GE">
		<cfquery name="rsGEmpresas" datasource="#session.dsn#">
			select GEid, GEnombre
			  from AnexoGEmpresa
			 where GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.GEid#">
		</cfquery>
		<strong>Grupo Empresas</strong> #rsGEmpresas.GEnombre#
		<input type="hidden" name="ANubicaGEid" 	value="#rsGEmpresas.GEid#">
		<input type="hidden" name="ANubicaEcodigo" 	value="-1">
		<input type="hidden" name="ANubicaOcodigo" 	value="-1">
		<input type="hidden" name="ANubicaGOid" 	value="-1">
	<cfelseif LvarANubicaTipo EQ "E">
		<cfquery name="rsEmpresas" datasource="#session.dsn#">
			select Ecodigo, Edescripcion
			  from Empresas
			 where Ecodigo = #Attributes.Ecodigo#
		</cfquery>
		<strong>Empresa</strong> #rsEmpresas.Edescripcion#
		<input type="hidden" name="ANubicaEcodigo" value="#rsEmpresas.Ecodigo#">
		<input type="hidden" name="ANubicaGEid" 	value="-1">
		<input type="hidden" name="ANubicaOcodigo" 	value="-1">
		<input type="hidden" name="ANubicaGOid" 	value="-1">
	<cfelseif LvarANubicaTipo EQ "O">
		<cfquery name="rsEmpresas" datasource="#session.dsn#">
			select Ecodigo, Edescripcion
			  from Empresas
			 where Ecodigo = #Attributes.Ecodigo#
		</cfquery>
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select Ocodigo, Odescripcion
			  from Oficinas
			 where Ecodigo = #Attributes.Ecodigo#
			   and Ocodigo = #Attributes.Ocodigo#
		</cfquery>
		<strong>Oficina</strong> #rsOficinas.Odescripcion# (en #rsEmpresas.Edescripcion#)
		<input type="hidden" name="ANubicaEcodigo" 	value="#rsEmpresas.Ecodigo#">
		<input type="hidden" name="ANubicaOcodigo" 	value="#rsOficinas.Ocodigo#">
		<input type="hidden" name="ANubicaGOid" 	value="-1">
		<input type="hidden" name="ANubicaGEid" 	value="-1">
	<cfelseif LvarANubicaTipo EQ "GO">
		<cfquery name="rsEmpresas" datasource="#session.dsn#">
			select Ecodigo, Edescripcion
			  from Empresas
			 where Ecodigo = #Attributes.Ecodigo#
		</cfquery>
		<cfquery name="rsGOficinas" datasource="#session.dsn#">
			select GOid, GOnombre
			  from AnexoGOficina
			 where GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.GOid#">
		</cfquery>
		<strong>Grupo Oficinas</strong> #rsGOficinas.GOnombre# (en #rsEmpresas.Edescripcion#)
		<input type="hidden" name="ANubicaEcodigo" 	value="#rsEmpresas.Ecodigo#">
		<input type="hidden" name="ANubicaGOid" 	value="#rsGOficinas.GOid#">
		<input type="hidden" name="ANubicaGEid" 	value="-1">
		<input type="hidden" name="ANubicaOcodigo" 	value="-1">
	<cfelse>
		INVALIDO
	</cfif>
	</cfoutput>
<cfelse>
	<cfif Attributes.tipo EQ "CALCULO">
		<cfset Attributes.Ecodigo = #session.Ecodigo#>
		<cfquery name="rsGOD" datasource="#session.DSN#">
			select GODid, GODdescripcion
			  from AnexoGOrigenDatos
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 order by GODdescripcion
		</cfquery>
	<cfelseif Attributes.Ecodigo EQ "" OR Attributes.Ecodigo EQ "-1">
		<cfset Attributes.Ecodigo = #session.Ecodigo#>
	</cfif>
	
	<cfquery name="rsEmpresas" datasource="#session.dsn#">
		select Ecodigo, Edescripcion
		  from Empresas
		 <cfif Attributes.tipo EQ "CONSULTA">
		 where Ecodigo = #attributes.Ecodigo#
		 <cfelse>
		 where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		 </cfif>
		 order by Edescripcion
	</cfquery>
	<cfquery name="rsGEmpresas" datasource="#session.dsn#">
		<cfif Attributes.tipo EQ "CALCULO">
		select ge.GEid, ge.GEnombre
		  from AnexoGEmpresa ge
			inner join AnexoGEmpresaDet gd
			   on gd.GEid = ge.GEid
			  and gd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 where ge.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		 order by ge.GEnombre
		<cfelse>
		select GEid, GEnombre
		  from AnexoGEmpresa
		 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		 order by GEnombre
		</cfif>
	</cfquery>
	
	<cfquery name="rsTodasOficinas" datasource="#Session.DSN#">
		SELECT Ecodigo, Ocodigo, Odescripcion 
		  FROM Oficinas o
		 <cfif Attributes.tipo EQ "CALCULO">
		 where Ecodigo = #session.Ecodigo#
		<cfelseif Attributes.tipo EQ "CONSULTA">
		 where Ecodigo = #attributes.Ecodigo#
		   and Ocodigo = #attributes.Ocodigo#
		<cfelse>
		 where exists
			(
				select 1
				  from Empresas e
				 where e.Ecodigo = o.Ecodigo
				   and e.cliente_empresarial = #session.CEcodigo#
			)
		 </cfif>
		order by Ecodigo, Odescripcion
	</cfquery>
	
	<cfquery name="rsTodasGOficinas" datasource="#session.dsn#">
		select Ecodigo, GOid, GOnombre
		  from AnexoGOficina o
		 <cfif Attributes.tipo EQ "CALCULO">
		 where Ecodigo = #session.Ecodigo#
		 <cfelse>
		 where exists
			(
				select 1
				  from Empresas e
				 where e.Ecodigo = o.Ecodigo
				   and e.cliente_empresarial = #session.CEcodigo#
			)
		 </cfif>
		order by Ecodigo, GOnombre
	</cfquery>
	
	<cfquery name="rsOficinas" dbtype="query">
		SELECT Ocodigo, Odescripcion 
		  FROM rsTodasOficinas
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#">
		 order by Odescripcion
	</cfquery>	
	<cfquery name="rsGOficinas" dbtype="query">
		select Ecodigo, GOid, GOnombre
		  from rsTodasGOficinas
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#">
		 order by GOnombre
	</cfquery>
	
	<table border="0" cellpadding="0" cellspacing="0" <cfif Attributes.tipo EQ "DISEÑO">width="400"<cfelse>width="300"</CFIF><cfif Attributes.tipo NEQ "CALCULO">style="border: 1px solid #CCCCCC" </cfif>align="left">
		<cfif Attributes.Propio AND Attributes.Tipo EQ "CALCULOCELDA">
		<tr>
			<td nowrap="nowrap" colspan="3">
				El Rango tiene Origen propio
			</td>
		</tr>
		</cfif>
		<tr>
		<cfif Attributes.tipo EQ "DISEÑO">
			<td nowrap="nowrap" colspan="5" style="border-bottom:1px solid #cccccc">
				<input type="radio"		name="ANubicaTipo" id="ANubicaTipo" value="" 	
						<cfif LvarANubicaTipo EQ "">checked</cfif>		
						onclick="return sbANubicacion('')">En Cálculo &nbsp;
				<input type="radio"		name="ANubicaTipo" id="ANubicaTipo" value="E" 	
						<cfif LvarANubicaTipo EQ "E">checked</cfif>		
						onclick="return sbANubicacion(this.value)">Empresa &nbsp;
				<input type="radio"		name="ANubicaTipo" id="ANubicaTipo" value="O" 	
						<cfif LvarANubicaTipo EQ "O">checked</cfif>		
						onclick="return sbANubicacion(this.value)">Oficina &nbsp;
			<cfif rsTodasGOficinas.recordcount GT 0>
				<input type="radio"		name="ANubicaTipo" id="ANubicaTipo" value="GO" 	
						<cfif LvarANubicaTipo EQ "GO">checked</cfif>	
						onclick="return sbANubicacion(this.value)">Grupo Oficinas &nbsp;
			</cfif>
			<cfif rsGEmpresas.recordcount GT 0>
				<input type="radio"		name="ANubicaTipo" id="ANubicaTipo" value="GE" 	
						<cfif LvarANubicaTipo EQ "GE">checked</cfif>	
						onclick="return sbANubicacion(this.value)">Grupo Empresas &nbsp;
			</cfif>
			</td>
		<cfelse>
			<td nowrap="nowrap" width="1">
				<select name="ANubicaTipo" id="ANubicaTipo" onchange="return sbANubicacion(this.value);">
					<option value="E"	<cfif LvarANubicaTipo EQ "E">selected</cfif>>Empresa</option>
					<option value="O"	<cfif LvarANubicaTipo EQ "O">selected</cfif>>Oficina</option>
				<cfif rsTodasGOficinas.recordcount GT 0>
					<option value="GO"	<cfif LvarANubicaTipo EQ "GO">selected</cfif>>Grupo Oficinas</option>
				</cfif>
				<cfif rsGEmpresas.recordcount GT 0>
					<option value="GE"	<cfif LvarANubicaTipo EQ "GE">selected</cfif>>Grupo Empresas</option>
				</cfif>
				<cfif Attributes.tipo EQ "CALCULO" AND rsGOD.recordcount GT 0>
					<option value="GOD"	<cfif LvarANubicaTipo EQ "GOD">selected</cfif>>Grupo Orig.Datos</option>
				</cfif>
				</select>
			</td>
		</cfif>
		<cfif Attributes.tipo NEQ "CALCULO">
		</tr>
		</cfif>
	<cfoutput>
		<cfif Attributes.tipo EQ "DISEÑO">
		<tr>
			<td id="TDubiE" nowrap="nowrap">
				Empresa:<BR>
		<cfelseif Attributes.tipo EQ "CALCULOCELDA">
		<tr id="TDubiE">
			<td nowrap="nowrap">
				Empresa:&nbsp;
			</td>
			<td nowrap="nowrap">
		<cfelse>
			<td id="TDubiE" nowrap="nowrap">
		</cfif>
				<select name="ANubicaEcodigo" id="ANubicaEcodigo" onchange="return sbANubicaEcodigo(this.value);">
					<cfloop query="rsEmpresas">
					  <option value="#rsEmpresas.Ecodigo#" <cfif rsEmpresas.Ecodigo EQ Attributes.Ecodigo>selected</cfif> >#rsEmpresas.Edescripcion#</option>
					</cfloop>
				</select>
			</td>
		<cfif Attributes.tipo EQ "DISEÑO">
			<td id="TDubiO" nowrap="nowrap">
				Oficina:<BR>  
		<cfelseif Attributes.tipo EQ "CALCULOCELDA">
		</tr>
		<tr id="TDubiO">
			<td nowrap="nowrap">
				Oficina:&nbsp;  
			</td>
			<td nowrap="nowrap">
		<cfelse>
			<td id="TDubiO" nowrap="nowrap">
		</cfif>
				<select name="ANubicaOcodigo" id="ANubicaOcodigo">
					<cfloop query="rsOficinas">
					  <option value="#rsOficinas.Ocodigo#" <cfif Attributes.modo NEQ "ALTA" and rsOficinas.Ocodigo EQ Attributes.Ocodigo>selected</cfif> >#rsOficinas.Odescripcion#</option>
					</cfloop>
					</select> 
				</select>
			</td>
		<cfif Attributes.tipo EQ "DISEÑO">
			<td id="TDubiGO" nowrap="nowrap">
				Grupo&nbsp;Oficinas:<BR>
		<cfelseif Attributes.tipo EQ "CALCULOCELDA">
		</tr>
		<tr id="TDubiGO">
			<td nowrap="nowrap">
				Grupo&nbsp;Oficinas:&nbsp;
			</td>
			<td nowrap="nowrap">
		<cfelse>
			<td id="TDubiGO" nowrap="nowrap">
		</cfif>
				<select name="ANubicaGOid" id="ANubicaGOid">
				<cfif rsGOficinas.recordCount EQ 0>
					  <option value="">(Empresa sin Grupo de Oficinas)</option>
				<cfelse>
					<cfloop query="rsGOficinas">
					  <option value="#rsGOficinas.GOid#" <cfif Attributes.modo NEQ "ALTA" and rsGOficinas.GOid EQ Attributes.GOid>selected</cfif> >#rsGOficinas.GOnombre#</option>
					</cfloop>
				</cfif>
				</select>
			</td>
		<cfif Attributes.tipo EQ "DISEÑO">
			<td id="TDubiGE" nowrap="nowrap">
				Grupo&nbsp;Empresas:<BR>  
		<cfelseif Attributes.tipo EQ "CALCULOCELDA">
		</tr>
		<tr id="TDubiGE">
			<td nowrap="nowrap">
				Grupo&nbsp;Empresas:&nbsp;
			</td>
			<td nowrap="nowrap">
		<cfelse>
			<td id="TDubiGE" nowrap="nowrap">
		</cfif>
				<select name="ANubicaGEid" id="ANubicaGEid">
					<cfloop query="rsGEmpresas">
					  <option value="#rsGEmpresas.GEid#" <cfif Attributes.modo NEQ "ALTA" and rsGEmpresas.GEid EQ Attributes.GEid>selected</cfif> >#rsGEmpresas.GEnombre#</option>
					</cfloop>
				</select>
			</td>
		<cfif Attributes.tipo EQ "DISEÑO">
			<td width="400" style="visibility:hidden">
				&nbsp;<BR><select><OPTION value=""></OPTION></select>
			</td>
		<cfelseif Attributes.tipo EQ "CALCULOCELDA">
		</tr>
		<tr id="TDblanco">
			<TD>&nbsp;</TD>
			<td style="visibility:hidden">
				<select><OPTION value=""></OPTION></select>
			</td>
		<cfelse>
			<td id="TDubiGOD" nowrap="nowrap">
				<select name="ANubicaGODid" id="ANubicaGODid">
				  <cfloop query="rsGOD">
					  <option value="#rsGOD.GODid#" <cfif Attributes.modo NEQ "ALTA" and rsGOD.GODid EQ Attributes.GODid>selected</cfif> >#rsGOD.GODdescripcion#</option>
				  </cfloop>
				</select>
			</td>
		</cfif>
		</tr>
	</table>
	</cfoutput>
	<script language="javascript">
		function sbANubicacion(LvarTipo)
		{
			document.getElementById("ANubicaTipo").value = LvarTipo;
			document.getElementById("TDubiE").style.display = "none";
			document.getElementById("TDubiO").style.display = "none";
			document.getElementById("TDubiGE").style.display = "none";
			document.getElementById("TDubiGO").style.display = "none";
		<cfif Attributes.tipo EQ "CALCULO">
			document.getElementById("TDubiGOD").style.display = "none";
		<cfelseif Attributes.tipo EQ "CALCULOCELDA">
			document.getElementById("TDblanco").style.display = "none";
		</cfif>
			if (LvarTipo != "")
			{
		<cfif Attributes.tipo EQ "CALCULO">
				if (LvarTipo == "E")
					document.getElementById("TDubiE").style.display = "";
		<cfelse>
				if (LvarTipo != "GE")
					document.getElementById("TDubiE").style.display = "";
			<cfif Attributes.tipo EQ "CALCULOCELDA">
				if (LvarTipo == "E" || LvarTipo == "GE")
					document.getElementById("TDblanco").style.display = "";
			</cfif>
		</cfif>
	
				document.getElementById("TDubi" + LvarTipo).style.display = "";
			}
			return true;
		}
	
		function sbANubicaEcodigo(Ecodigo)
		{
			var cboOcodigo = document.getElementById("ANubicaOcodigo");
			
			while (cboOcodigo.length > 0)
				cboOcodigo.remove (0);
			
			if (Ecodigo == -1)
			{
				cboOcodigo.options[0] = new Option ("(Escoja una Empresa)","");
			<cfoutput query="rsTodasOficinas" group="Ecodigo">
			}
			else if (Ecodigo == #Ecodigo#)
			{
			  <cfset LvarI = 0>
			  <cfoutput group="Ocodigo">
				cboOcodigo.options[#LvarI#] = new Option ("#Odescripcion#","#Ocodigo#");
				<cfset LvarI = LvarI + 1>
			  </cfoutput>
			</cfoutput>
			}
			else
			{
				cboOcodigo.options[0] = new Option ("(Empresa sin Oficinas)","");
			}
	
			// Grupo de oficinas
			var cboGOid = document.getElementById("ANubicaGOid");
			while (cboGOid.length > 0)
				cboGOid.remove (0);
			
			if (Ecodigo == -1)
			{
				cboGOid.options[0] = new Option ("(Escoja una Empresa)","");
			<cfoutput query="rsTodasGOficinas" group="Ecodigo">
			}
			else if (Ecodigo == #Ecodigo#)
			{
			<cfset LvarI = 0>
			<cfoutput group="GOid">
				cboGOid.options[#LvarI#] = new Option ("#GOnombre#","#GOid#");
				<cfset LvarI = LvarI + 1>
			</cfoutput>
			</cfoutput>
			}
			else
			{
				cboGOid.options[0] = new Option ("(Empresa sin Grupo de Oficinas)","");
			}
		}
	
		function fnANubicaVerifica()
		{
			var LvarTipo = document.getElementById("ANubicaTipo").value;
			
			if (LvarTipo == "GE")
			{
				if (document.getElementById("ANubicaGEid").value == "")
				{
					alert ("ERROR: Debe indicar el Grupo de Empresas");
					return false;
				}
			}
			else if (document.getElementById("ANubicaEcodigo").value == "")
			{
				alert ("ERROR: Debe indicar la Empresa");
				return false;
			}
			else if (LvarTipo == "O")
			{
				if (document.getElementById("ANubicaOcodigo").value == "")
				{
					alert ("ERROR: Debe indicar la Oficina");
					return false;
				}
			}
			else if (LvarTipo == "GO")
			{
				if (document.getElementById("ANubicaGOid").value == "")
				{
					alert ("ERROR: Debe indicar el Grupo de Oficinas");
					return false;
				}
			}
			return true;
		}
	
		<cfoutput>
		<cfif Attributes.Tipo EQ "DISEÑO">
			sbANubicacion("#LvarANubicaTipo#");
		<cfelse>
			var OcodigoIdx 	= document.getElementById("ANubicaOcodigo").selectedIndex;
			var GOidIdx		= document.getElementById("ANubicaGOid").selectedIndex;
	
			sbANubicacion(document.getElementById("ANubicaTipo").value);
			sbANubicaEcodigo(document.getElementById("ANubicaEcodigo").value);
	
			if (OcodigoIdx < 0)
				document.getElementById("ANubicaOcodigo").selectedIndex	= 0;
			else if (OcodigoIdx <= document.getElementById("ANubicaOcodigo").length)
				document.getElementById("ANubicaOcodigo").selectedIndex	= OcodigoIdx;
	
			if (GOidIdx < 0)
				document.getElementById("ANubicaGOid").selectedIndex = 0;
			else if (GOidIdx <= document.getElementById("ANubicaGOid").length)
				document.getElementById("ANubicaGOid").selectedIndex = GOidIdx;
		</cfif>
		</cfoutput>
	</script>
</cfif>

