<cfquery name="rsNivel" datasource="#Session.DSN#">
select -1 as Ncodigo , 'Todos'  as Ndescripcion
union all 
SELECT Ncodigo, Ndescripcion FROM Nivel where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
</cfquery>

	<form name="formFiltro" method="post" action="">
	<hr>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
		<td width="51%">Descripcion 

        <input name="DesFiltro" type="text" id="DesFiltro" size="60" maxlength="255" value="<cfif isdefined("Form.DesFiltro") and len(trim(#Form.DesFiltro#)) NEQ 0><cfoutput>#Form.DesFiltro#</cfoutput></cfif>"></td>
		<td width="7%">Nivel</td>
		<td width="15%">
			<select name="NcodigoFiltro" id="NcodigoFiltro">
			  <cfoutput query="rsNivel"> 
				<option value="#Ncodigo#" <cfif (isDefined("form.NcodigoFiltro") AND #form.NcodigoFiltro# EQ #rsNivel.Ncodigo#)>selected </cfif>>#rsNivel.Ndescripcion# 
				</option>
			  </cfoutput> 
			</select>						
		</td>
		<td width="4%">Orden</td>
		<td width="15%"><input name="OrdenFiltro" type="text" id="OrdenFiltro" size="8" maxlength="8" value="<cfif isdefined("Form.OrdenFiltro") and len(trim(#Form.OrdenFiltro#)) NEQ 0><cfoutput>#Form.OrdenFiltro#</cfoutput></cfif>" onfocus="this.value=qf(this); this.select();" onblur="fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
		<td width="8%"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
	  </tr>
	</table>
	<hr>
	
	</form>