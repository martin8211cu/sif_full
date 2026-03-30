<cfif Len(form.ACid)>
	<cfinclude template="../../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.dsn#" name="rsinfocalculo">
	Select anx.AnexoDes, e.ACid, e.AnexoId, e.ACano, e.ACmes, e.Mcodigo,	e.ACunidad,
		  case 
		  	when e.Mcodigo = -1 then 'Todas las Monedas (expresado en Local)' 
		  	when e.ACmLocal = -1 then m.Mnombre #_Cat# ' (expresado en Local)' 
			else m.Mnombre 
		  end as Moneda,
		  case when e.Mcodigo = -1 OR e.ACmLocal = 1 then 'En Local' else m.Mnombre end as Expresion,
	  	  case when e.Ecodigo != -1 then 'Empresa: ' #_Cat# emp.Edescripcion
			   when e.Ocodigo != -1 then 'Oficina: ' #_Cat# o.Odescripcion
			   when e.GEid    != -1 then 'Grupo Empresas: ' #_Cat# ge.GEnombre
			   when e.GOid    != -1 then 'Grupo Oficinas: ' #_Cat# go.GOnombre	end as Calculadopara
	from AnexoCalculo e
		inner join Anexo anx
			on anx.AnexoId = e.AnexoId	
		left join Empresas emp
			on emp.Ecodigo = e.Ecodigo		
		left join Monedas m
			on m.Mcodigo = e.Mcodigo
		left join Oficinas o
			on  o.Ocodigo = e.Ocodigo
			and o.Ecodigo = e.Ecodigo
		left join AnexoGEmpresa ge
			on ge.GEid = e.GEid
		left join AnexoGOficina go
			on go.GOid = e.GOid
	Where e.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#">
	  and e.ACstatus = 'T' 
	  and ((e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) or (e.Ecodigo = -1 and e.GEid != -1 				
	  and exists (select Ecodigo 
				  from AnexoGEmpresaDet ged where ged.GEid = e.GEid
				  and ged.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)))
				  order by e.ACano desc, e.ACmes desc, e.Mcodigo asc, 
				  e.GEid asc, e.GOid asc,	e.Ocodigo asc, e.ACunidad asc
	</cfquery>


	<cfquery datasource="#session.dsn#" name="rsGrupo">
	Select A.GAid
	from Anexo A, AnexoGrupo B
	where A.GAid=B.GAid
	   and A.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">	   
   </cfquery>

	<cfif rsGrupo.recordcount gt 0>
		<cfset grupoanex = rsGrupo.GAid>
	<cfelse>
		<cf_errorCode	code = "50155" msg = "No existe un grupo definido para el anexo">
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsAnexoXml">
		select e.ACid, e.AnexoId, e.ts_rversion
		from AnexoCalculo e
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">		  
		  and ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#">
		  and ACstatus = 'T'
		  and ((e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		   or (e.Ecodigo = -1 and e.GEid != -1 
		  and exists (select Ecodigo 
		   			  from AnexoGEmpresaDet ged
					  where ged.GEid = e.GEid
					    and ged.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)))
	</cfquery>
	
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="tsurl"
		arTimeStamp="#rsAnexoXml.ts_rversion#"/>
</cfif> 

<form name="formAnexoMain" id="formAnexoMain" method="get" action="index.cfm">
<cfoutput>
	<input type="hidden" name="AnexoId" id="AnexoId" value="#HTMLEditFormat(form.AnexoId)#">
	<input type="hidden" name="ACid" id="ACid" value="#HTMLEditFormat(form.ACid)#">	
</cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<cfoutput query="rsinfocalculo">
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="ayuda">
			<tr><td width="9%">&nbsp;</td></tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Anexo:</strong></td>
				<td width="31%">#AnexoDes#</td>				
				<td width="14%"><strong>Moneda:</strong></td>
				<td width="46%">#Moneda#</td>
				<td width="46%">
				  <input type="button" name="Recalcular" value="Repetir c&aacute;lculo... " style="width:100px" onclick="recalcular(this.form)">
				  <input type="button" name="Descargar" id="Descargar" value="Descargar archivo" style="width:100px" onclick="descargar_archivo(this.form)" style="display:none ">				  
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>A&ntilde;o:</strong></td>
				<td>#ACano#</td>
				<td><strong>Unidad:</strong></td>
				<td colspan="3">#ACunidad#</td>
			</tr>
			<tr>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Mes:</strong></td>
				<td>#ACmes#</td>
				<td><strong>Calculado para:</strong></td>
				<td>#Calculadopara#</td>				
				<td>
					<input type="button" name="Regresar" value="Regresar " style="width:100px" onclick="javascript:document.location='newindex.cfm'">					
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>					      
			<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput>
		</td>
	</tr>	
		<!--- 
		<tr>
		  <td colspan="10">		  
		  C&aacute;lculos realizados:
		  <select name="ACid" onchange="cargar_anexo(this.form)">
		  <option value="">-seleccione-</option>
		  <cfoutput query="lista">
		  	<option value="#ACid#" <cfif lista.ACid EQ url.ACid>selected</cfif>>#ACmes#/#ACano# (#HTMLEditFormat(Moneda)#) - #HTMLEditFormat(Oficina)# </option>
		  </cfoutput>
		  </select>		   
		  </td>
	  </tr>
	  --->
		
		<tr> 
			<td> 
			<cfoutput>
			
				<object classid="CLSID:0002E559-0000-0000-C000-000000000046" id="grid" width="100%" 
					<cfif Len(form.ACid)>
						data="download/download.cfm?AnexoId=#rsAnexoXml.AnexoId#&amp;ACid=#rsAnexoXml.ACid#&amp;ts=#tsurl#"
					</cfif>				
				>
				<img src="../../images/noxl-edit.gif" id="imganexo" name="imganexo" width="695" height="288">
				<!--- <img src="about:blank" width="1" height="1" align="left"> --->
				</object>
				
				<script>			
				var bandera=0;					
				if (!document.getElementById('grid')) 
				{
				  //Si no esta definida la instancia del objeto, se carga el otro
				  bandera=1;
				  document.getElementById('imganexo').width = 0;
				  document.getElementById('imganexo').height = 0;				  
				  <cfif Len(form.ACid)>
				  	document.writeln('<object classid="CLSID:0002E551-0000-0000-C000-000000000046" id="grid" width="100%" data="download/download.cfm?AnexoId=#rsAnexoXml.AnexoId#&amp;ACid=#rsAnexoXml.ACid#&amp;ts=#tsurl#">');
				  <cfelse>
					document.writeln('<object classid="CLSID:0002E551-0000-0000-C000-000000000046" id="grid" width="100%">');				  			  
				  </cfif>
				  document.writeln('<img src="../../images/noxl-edit.gif" id="imganexo1" name="imganexo1" width="695" height="288">');
				  document.writeln('</object>');
				}
				</script>				
				<script type="text/javascript">	
					if(!document.getElementById('imganexo') && !document.getElementById('imganexo1'))
					{					
							//Si no existe ninguna de las 2 imagenes hay un objeto cargado
							bandera=1;
					}
					else
					{	
						if(document.getElementById('imganexo') && document.getElementById('imganexo1'))
						{					
								//Si existen las 2 imagenes no hay un objeto cargado
								bandera=0;
						}					
					}								
					if(document.getElementById('imganexo') && bandera==0)
					{
						document.mostrarDescargar= true;
					}
				</script>
				
			</cfoutput>
			</td>
		</tr>
		<!---
		<tr><td>&nbsp;</td></tr>
		<tr>
		  <td align="center">  
	      <input type="button" name="Regresar" value="Regresar " style="width:150px" onclick="javascript:document.location='newindex.cfm'">
		  <input type="button" name="Recalcular" value="Repetir c&aacute;lculo... " style="width:150px" onclick="recalcular(this.form)">
	      <input type="button" name="Descargar" id="Descargar" value="Descargar archivo" onclick="descargar_archivo(this.form)" style="display:none "></td>
	    </tr> --->
	  
	</table>
</form>

<script type="text/javascript" for="grid" event="LoadCompleted">
	var g = document.all.grid;
	g.ActiveWorkbook.Protect();
	var Sheets = g.ActiveWorkbook.Sheets;
	for (i=1;i<=Sheets.count;i++){
		Sheets.Item(i).Protect();
	}
</script>

<script type="text/javascript">
<!--
	function grid_loadcompleted(){
		alert("grid_loadcompleted");
	}

	function recalcular(f){
		window.open( "../calculo/index.cfm?AnexoId="+escape(f.AnexoId.value)+
				   "&GAid=<cfoutput>#JSStringFormat(grupoanex)#</cfoutput>", "_self");
	}
	function cargar_anexo(f){
		if (document.all && document.all.grid) {
			var g = document.all.grid;
			g.ActiveWorkbook.UnProtect();
			var Sheets = g.ActiveWorkbook.Sheets;
			for (i=1;i<=Sheets.count;i++){
				Sheets.Item(i).UnProtect();
				Sheets.Item(i).Cells.Clear();
				if (!f.ACid.value.length) {
					Sheets.Item(i).Protect();
				}
			}
			if (f.ACid.value.length) {
				var d = new Date();
				g.XMLURL = "download/download.cfm?AnexoId="+escape(f.AnexoId.value)+
						   "&ACid="+escape(f.ACid.value)+"&tsurl="+d;
			}
		}
	}
	function descargar_archivo(f){
		if (f.ACid.value.length) {
			var d = new Date();
			window.open("download/download.cfm?AnexoId="+escape(f.AnexoId.value)+
			           "&ACid="+escape(f.ACid.value)+"&tsurl="+d, "_self");
		}
	}
	if(document.mostrarDescargar)document.getElementById('Descargar').style.display="inline";
//-->
	cargar_anexo(document.formAnexoMain)
</script>



