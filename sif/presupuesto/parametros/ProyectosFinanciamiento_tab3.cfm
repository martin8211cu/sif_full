<form name="frmSPry">
	<table>
		<tr>
			<td>
				<strong>Codigo SubProyecto:</strong>
			</td>
			<td>
				<input type="text" size="10" name="cod" tabindex="1" value="<cfoutput>#rtrim(rsdata.CPPFcodigo)#</cfoutput>.">
			</td>
		</tr>
		<tr>
			<td>
				<strong>Descripcion:</strong>
			</td>
			<td>
				<input type="text" size="40" name="dsc" tabindex="1">
			</td>
		</tr>
		<tr>
			<td>
			</td>
			<td>
				<input type="checkbox" name="conFin" tabindex="1" checked>
				Requiere Financiamiento
			</td>
			<td>
				<input name="btnAdd_Ctas" value="+" tabindex="1" type="button" onclick="if((this.form.cod.value != '<cfoutput>#rtrim(rsdata.CPPFcodigo)#</cfoutput>.') && (this.form.dsc.value != '')) SPry_add(this.form.cod.value,this.form.dsc.value,(this.form.conFin.checked ? 1 : 0));"/>
			</td>
		</tr>
		</form>
		
		<tr>
			<td colspan="3">
				<cf_dbfunction name="to_char" args="CPPFid" returnvariable="LvarCPPFid">
				<cf_dbfunction name="OP_concat" returnvariable="CAT">
				<cfset LvarIMG = '''<img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Cuenta" style="cursor:pointer" onclick="SPry_del('''''' #cat# #LvarCPPFid# #cat# '''''');">'' as IMG'>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="CPproyectosFinanciados"/>
					<cfinvokeargument name="columnas" value="CPPFid, CPPFcodigo, CPPFdescripcion, case when CPPFconFinanciamiento=0 then 'NO' end as Financiado, #LvarIMG#"/>
					<cfinvokeargument name="filtro" value="CPPFid_padre=#form.CPPFid#"/>
					<cfinvokeargument name="desplegar" value="CPPFcodigo, CPPFdescripcion, Financiado, IMG"/>
					<cfinvokeargument name="etiquetas" value="SubProyecto,Descripci&oacute;n,Financiado, "/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
					<cfinvokeargument name="align" value="left,left,center,center,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
					<cfinvokeargument name="irA" value="ProyectosFinanciamiento.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value=""/>
					<cfinvokeargument name="PageIndex" value="3"/>
					<cfinvokeargument name="MaxRows" value="0"/>
				 </cfinvoke>
				 <script language="javascript">
					function SPry_add(cod, dsc, conFin)
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnAdd_SPry&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>&cod=' + escape(cod) + '&dsc=' + escape(dsc) + '&conFin=' + conFin;
					}
					function SPry_del(msk)
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnDel_SPry&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>';
					}
				 </script>
			</td>
		</tr>
	</table>
	