<form name="frmCF">
	<table>
		<tr>
			<td>
				<strong>Centro Funcional:</strong>
			</td>
			<td>
				<cf_rhcfuncional id="CFid" form="frmCF">
			</td>
			<td>
				<input name="btnAdd_CF" value="+" type="button" onclick="if(this.form.CFid.value != '') CF_add(this.form.CFid.value);"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input name="btnSyn_CF" value="Sincronizar Máscaras" type="button" onclick="CF_syn();"/>
			</td>
		</tr>
		
		<tr>
			<td colspan="3">
				<cf_dbfunction name="OP_concat" returnvariable="CAT">
				<cf_dbfunction name="to_char" args="p.CFid" returnvariable="LvarCFid">
				<cfset LvarIMG = '''<img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Centro Funcional" style="cursor:pointer" onclick="CF_del('' #cat# #LvarCFid# #cat# '');">'' as IMG'>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="CPproyectosFinanciadosCFs p inner join CFuncional cf on cf.CFid=p.CFid"/>
					<cfinvokeargument name="columnas" value="CPPFid, cf.CFid, cf.CFcodigo, cf.CFdescripcion, #LvarIMG#, CFpath"/>
					<cfinvokeargument name="filtro" value="CPPFid=#form.CPPFid# and CPPid=#session.CPPid# order by CFpath"/>
					<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion, IMG"/>
					<cfinvokeargument name="etiquetas" value="Codigo, Descripci&oacute;n, "/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
					<cfinvokeargument name="align" value="left,left,center,center,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
					<cfinvokeargument name="irA" value="ProyectosFinanciamiento.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value=""/>
					<cfinvokeargument name="PageIndex" value="2"/>
					<cfinvokeargument name="MaxRows" value="0"/>
					<cfinvokeargument name="showLink" value="false"/>
				 </cfinvoke>
				 <script language="javascript">
					function CF_add(CFid)
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnAdd_CF&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>&CFid=' + CFid;
					}
					function CF_del(CFid)
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnDel_CF&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>&CFid=' + CFid;
					}
					function CF_syn()
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnSyn_CF&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>';
					}
				 </script>
			</td>
		</tr>
	</table>
</form>
