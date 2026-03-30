<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_NombreAnexo" 	default="Nombre del Anexo" 
returnvariable="LB_NombreAnexo" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Grupo" 	default="Grupo" 
returnvariable="LB_Grupo" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Secuencia" 	default="Secuencia para C&aacute;lculo" 
returnvariable="LB_Secuencia" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_OpcionesCalculo" 	default="Opciones de C&aacute;lculo con SOINanexos" returnvariable="LB_OpcionesCalculo" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_OcultaColumnas" 	default="Ocultar Columnas" returnvariable="CHK_OcultaColumnas" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_OcultaFilas" 	default="Ocultar Filas" returnvariable="CHK_OcultaFilas" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CopiarAnexo" 	default="Copiar Anexo" returnvariable="LB_CopiarAnexo" xmlfile="anexo-head.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Guardar" 	default="Guardar" returnvariable="BTN_Guardar" xmlfile="anexo-head.xml"/>


<cfquery name="rsAnexo" datasource="#session.DSN#">
	select AnexoId, GAid, AnexoDes, AnexoSeq
			, AnexoOcultaFilas
			, AnexoOcultaColumnas
			, coalesce(AnexoSaldoConvertido, 0) as AnexoSaldoConvertido
	from Anexo
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">   	  
</cfquery>
<cfquery name="rsGrupos" datasource="#session.dsn#">
	select GAid, GAnombre, GAprofundidad
	from AnexoGrupo
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by GAruta
</cfquery>
<cfquery name="rsGruposHijos" datasource="#session.dsn#">
	select GAid, GAnombre, GApadre, GAprofundidad
	from AnexoGrupo
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	and GApadre IS NOT NULL
	order by GApadre, GAruta, GAnombre
</cfquery>
<cfoutput>
<form enctype="multipart/form-data" name="anexoHead" action="anexo-head-apply.cfm" method="post" onsubmit="return validate_head_form(this);">
<input type="hidden" name="AnexoId" id="AnexoId" value="#rsAnexo.AnexoId#">
<table  border="0" bgcolor="##ededed" cellpadding="3" cellspacing="0" width="950" align="center"> 
<tr>
	<td><strong>#LB_NombreAnexo#:</strong></td>
	<td><strong>#LB_Grupo#:</strong></td>
	<td><strong>#LB_Secuencia#:</strong></td>
</tr>
<tr>
	<td><input type="text" size="40" maxlength="60" name="AnexoDes" id="AnexoDes" value="#HTMLEditFormat(Trim(rsAnexo.AnexoDes))#" onfocus="this.select()"></td>
	<td>
		<select name="GAid">
		<cfloop query="rsGrupos"><option value="#GAid#" <cfif GAid eq rsAnexo.GAid>selected</cfif>>
			#RepeatString('&nbsp;', GAprofundidad)#
		#HTMLEditFormat(GAnombre)#&nbsp;&nbsp;&nbsp;</option>
		</cfloop>
		</select>
	</td>
	<td><input name="AnexoSeq" type="text" id="AnexoSeq" value="<cfif Len(rsAnexo.AnexoSeq)>#HTMLEditFormat(rsAnexo.AnexoSeq)#<cfelse>0</cfif>" size="10" maxlength="10" onfocus="this.select()"></td>
</tr>
<tr>
	<td><strong>#LB_OpcionesCalculo#:</strong></td>
	<cfif isdefined("url.ANEXOID") and url.ANEXOID NEQ 0>
	<cfelse>
	<td><input name="copia_anexo_check" type="checkbox" value="yes" onclick="javascript:copiaranexos();"/><strong>#LB_CopiarAnexo#:</strong></td>
	</cfif>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<input type="checkbox" id="chkOcultarFilas" name="chkOcultarFilas" 	 style="background-color:##ededed;" <cfif rsAnexo.AnexoOcultaFilas EQ "1">checked </cfif>><label for="chkOcultarFilas">#CHK_OcultaFilas#</label>
		<input type="checkbox" id="chkOcultarColumnas" name="chkOcultarColumnas" style="background-color:##ededed;" <cfif rsAnexo.AnexoOcultaColumnas EQ "1">checked </cfif>><label for="chkOcultarColumnas">#CHK_OcultaColumnas#</label>
		<select name="cboSaldosConvertidos">
			<option value="0" <cfif rsAnexo.AnexoSaldoConvertido EQ "0">selected</cfif>>Saldos Normal</option>
			<option value="1" <cfif rsAnexo.AnexoSaldoConvertido EQ "1">selected</cfif>>Saldos Convertidos</option>
			<option value="2" <cfif rsAnexo.AnexoSaldoConvertido EQ "2">selected</cfif>>Saldos Multimoneda</option>
			<option value="3" <cfif rsAnexo.AnexoSaldoConvertido EQ "3">selected</cfif>>Saldos Funcional B15</option> <!--- JMRV --->
			<option value="4" <cfif rsAnexo.AnexoSaldoConvertido EQ "4">selected</cfif>>Saldos Informe B15</option>   <!--- JMRV --->
		</select>			
		<input type="hidden" name="excel">
		<!---
		(utilice la opcion [Cargar con SOINanexos])
		--->
	</td>
	<cfif isdefined("url.ANEXOID") and url.ANEXOID NEQ 0>
		<input name="Copiar_Anexo_FID" type="hidden" value="0" />
		<input name="Copiar_Anexo_ID" type="hidden" value="0" />
	<cfelse>
	<td>
		<select name="Copiar_Anexo_FID" disabled onChange="procEst();">
			<option value="0">Seleccione</option>
		<cfloop query="rsGrupos"><option value="#GAid#">
			#RepeatString('&nbsp;', GAprofundidad)#
		#HTMLEditFormat(GAnombre)#&nbsp;&nbsp;&nbsp;</option>
		</cfloop>
		</select>
		<select name="Copiar_Anexo_ID" size="1" disabled>
			<option value="0">Seleccione</option>
		</select>
	</td>
	</cfif>
	<td valign="middle"><input type="submit" name="Guardar" value="#BTN_Guardar#"></td>
</tr>
	  <cfparam name="url.msg" default="">
	  <cfif Len(trim(url.msg))>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td colspan="3" style="color:white;font-weight:bold;background-color:red;">#HTMLEditFormat( url.msg )#</td>
	<td>&nbsp;</td>
</tr>
</cfif>
</table>
</form>
<script type="text/javascript" defer>
<!--
	function validate_head_form(f){
		var msg = "";
		if (!f.AnexoDes.value.length){
			msg += "\r\n - La descripción es requerida";
		}
		if (f.excel.value.length && !f.excel.value.match(/.+\.xml$/)) {
			msg += "\r\n - El archivo debe ser un excel en formato XML";
		}
		if (!f.AnexoSeq.value.match(/^[0-9]+$/)) {
			msg += "\r\n - La secuencia para cálculo debe ser un número entero";
		}
		if (msg.length) {
			alert("Por favor resuelva los siguientes errores:" + msg);
			return false;
		}
		return true;
	}
//-->
	function copiaranexos()
	{
		if (document.anexoHead.Copiar_Anexo_FID.disabled == true)
		{
			document.anexoHead.Copiar_Anexo_FID.disabled=false
			document.anexoHead.Copiar_Anexo_ID.disabled=false
		}
		else
		{
			document.anexoHead.Copiar_Anexo_FID.disabled=true
			document.anexoHead.Copiar_Anexo_ID.disabled=true
		}
	}
	
	<cfif isdefined("url.ANEXOID") and url.ANEXOID NEQ 0>
	<cfelse>
	function procEst() 
	{
		var lista = document.anexoHead.Copiar_Anexo_FID;
		i = document.anexoHead.Copiar_Anexo_FID.selectedIndex;

		var dropdownObjectPath = document.anexoHead.Copiar_Anexo_ID;
		var wichDropdown = "Copiar_Anexo_ID";
		var withWhat = lista.options[lista.selectedIndex].value;
	
		populateOptions(wichDropdown, withWhat);
	}
	
	function populateOptions(wichDropdown, withWhat) 
	{
	
		o = new Array;
		i=0;
		
		if (withWhat == "0") {
			o[i++]=new Option("Seleccione", "0");  
			}
		
		<cfset Temp_GrupoPadre = "">
		<cfset Temp_cont = 0>
		<cfquery name="rsGruposHijosAnexos" datasource="#session.dsn#">
			select AnexoId, GAid, AnexoDes
			from Anexo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			order by GAid
		</cfquery>
		<cfloop query="rsGruposHijosAnexos">
			<cfset Temp_cont = Temp_cont + 1>
			<cfif Temp_GrupoPadre NEQ GAid>
				<cfif Temp_cont NEQ 1>
			}
				</cfif>
				<cfset Temp_GrupoPadre = GAid>
			if (withWhat == "#GAid#") {
				o[i++]=new Option("Seleccione", "0");
			</cfif>
				o[i++]=new Option("#HTMLEditFormat(AnexoDes)#", "#AnexoId#");
			<cfif Temp_GrupoPadre NEQ GAid>
			</cfif>
		</cfloop>
		<cfif Temp_cont GT 1>
			}
		</cfif>
	
		if (i==0) {
			//alert(i + " " + "Error!!!");
				o[i++]=new Option("", "0");
			}
		dropdownObjectPath = document.anexoHead.Copiar_Anexo_ID;
		eval(document.anexoHead.Copiar_Anexo_ID.length=o.length);
		largestwidth=0;
		for (i=0; i < o.length; i++) 
			{
			  eval(document.anexoHead.Copiar_Anexo_ID.options[i]=o[i]);
			  if (o[i].text.length > largestwidth) {
				 largestwidth=o[i].text.length;    }
			}
		eval(document.anexoHead.Copiar_Anexo_ID.length=o.length);
		//eval(document.myform.ciudad.options[0].selected=true);
	}
	procEst();
	</cfif>
</script>
</cfoutput>