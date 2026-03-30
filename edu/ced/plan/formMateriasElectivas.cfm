<!---REALIZA LAS CONSULTAS--->
<cfquery datasource="#Session.Edu.DSN#" name="rsMateria">
	select c.Mnombre, a.Ndescripcion, b.Gdescripcion ,
		   case c.Melectiva
				when 'R' then 'Regular'
				when 'S' then 'Sustitutiva'
				when 'E' then 'Electiva'
				when 'C' then 'Complementaria'
				else ''
			end as Modalidad,
			d.MTdescripcion,
			c.Mconsecutivo
	from Nivel a, Grado b, Materia c, MateriaTipo d
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and c.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	  and a.Ncodigo = b.Ncodigo 
	  and b.Ncodigo = c.Ncodigo 
	  and b.Gcodigo = c.Gcodigo 
	  and c.MTcodigo = d.MTcodigo
	 order by a.Norden, b.Gorden
</cfquery>

<!------------------------------Aplica las Materias Lectivas-------------------------------------------->
<cfif isdefined("Form.btnAplicar")>
	<cfquery name="ABC_MateriaElectiva" datasource="#Session.Edu.DSN#">
		set nocount on
		
		delete MateriaElectiva 
		where Mconsecutivo in  (#form.Cual_Grupo#)  
		  and Melectiva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mconsecutivo#">
		
		
		set nocount off
	</cfquery>
	<cfif isdefined("Form.Chk")>
		<cfset a=ListToArray(Form.Chk,',')>
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			 <cfset Melectiva = b[1]>
			<cfquery name="ABC_MateriaElectiva" datasource="#Session.Edu.DSN#">
					set nocount on
					insert MateriaElectiva ( Mconsecutivo, Melectiva)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Melectiva#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mconsecutivo#">
								)
					set nocount off
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<!---------------------------------------------------------------------------------- --->

<table width="100%" border="0"  cellpadding="0" cellspacing="0">
	<tr><td>
		<form name="filtros" action="MateriasElectivas.cfm" method="post" style="margin:0">
			<input name="Mnombre" type="hidden" id="Mnombre" value="<cfif isdefined("Form.Mnombre")><cfoutput>#Form.Mnombre#</cfoutput></cfif>">
				<table width="100%"  cellpadding="0" cellspacing="0" class="tituloAlterno">
					<thead>
						<tr> 
							<td colspan="5" align="center">Datos de Materia</td>
						</tr>
						<tr> 
							<td colspan="5" align="center">&nbsp;</td>
						</tr>
					</thead>
					<tbody>
						<tr> 
							<td width="35%" rowspan="2" align="center" valign="middle" style="font-size: 13pt; font-weight: bold;" nowrap><cfoutput>#rsMateria.Mnombre#</cfoutput></td>
							<td nowrap><strong>Nivel:</strong> <cfoutput>#rsMateria.Ndescripcion#</cfoutput> </td>
							<td nowrap><strong>Tipo de Materia:</strong> <cfoutput>#rsMateria.MTdescripcion#</cfoutput></td>
						</tr>
						<tr> 
							<td nowrap> <strong>Grado:</strong> <cfoutput>#rsMateria.Gdescripcion#</cfoutput> </td>
							<td nowrap><strong>Modalidad:</strong> <cfoutput>#rsMateria.Modalidad#</cfoutput></td>
						</tr>
					</tbody>
				</table>
		</form>
	</td></tr>
	<tr><td>		
		
		<form name="lista2" method="post" action="MateriasElectivas.cfm" style="margin:0">
			<!----id de la lista principal que se envia por el form para no perder el valor--->
			<input type="hidden" name="Mconsecutivo" value="<cfif isdefined("Form.Mconsecutivo")><cfoutput>#Form.Mconsecutivo#</cfoutput></cfif>">
			<!----pagina de la lista principal que se envia por el form para no perder el valor--->
			<input type="hidden" name="pagina" value="<cfoutput>#form.pagina#</cfoutput>">
			<!----Filtros de la lista principal que se envia por el form para no perder el valor--->
			<input type="hidden" name="Filtro_Mnombre" value="<cfoutput>#form.Filtro_Mnombre#</cfoutput>">
			<input type="hidden" name="Filtro_Mhoras" value="<cfoutput>#form.Filtro_Mhoras#</cfoutput>">
			<input type="hidden" name="Filtro_Mcreditos" value="<cfoutput>#form.Filtro_Mcreditos#</cfoutput>">
			<!---Otras variables usadas anterioimente.--->
			<input name="Mnombre" type="hidden" id="Mnombre" value="<cfif isdefined("Form.Mnombre")><cfoutput>#Form.Mnombre#</cfoutput></cfif>">
			<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
			
			<cfif isdefined("Form.Pagina2") and Form.Pagina2 NEQ "">
				<cfset Pagenum_lista2 = #Form.Pagina2#>
			</cfif>
			
			<!--- NAVEGACION EN LA LISTA DE DETALLES--->
			<!--- Navegacion de la lista de destalles---> 
			<cfset navegacion = "Mconsecutivo=" & Form.Mconsecutivo>
			<!--- <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre=" & Form.Mnombre> --->
			
			<!--- ID de la lista principal--->
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mconsecutivo=" & Form.Mconsecutivo>
			<!--- Pagina de la lista principal --->
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "pagina=" & Form.pagina>
			<!--- filtros de la lista principal--->
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mnombre=" & Form.Filtro_Mnombre>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mhoras=" & Form.Filtro_Mhoras>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mcreditos=" & Form.Filtro_Mcreditos>
			
			 
			<cfinvoke 
				 component="edu.Componentes.pListas"
				 method="pListaEdu"
				 returnvariable="pListaEduRet">
					<cfinvokeargument name="tabla" value=" Materia a, MateriaTipo mt, MateriaElectiva me"/>
					<cfinvokeargument name="columnas" value=" a.Mconsecutivo as KMateria, a.Melectiva, 
											substring(a.Mnombre,1,50) as Mnombre2, a.Mhoras as Mhoras2, a.Mcreditos as Mcreditos2, a.Ncodigo, 
											a.Gcodigo, convert(varchar, me.Mconsecutivo) as checked
											"/>
					<cfinvokeargument name="desplegar" value="Mnombre2, Mhoras2, Mcreditos2"/>
					<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Horas mayor a, Cr&eacute;ditos mayor a"/>
					<cfinvokeargument name="filtro" value="a.Melectiva = 'S'
															and me.Melectiva = #form.Mconsecutivo# 
															and mt.CEcodigo = #Session.Edu.CEcodigo# 
															and a.Mconsecutivo in
															(select c.Mconsecutivo
																from GradoSustitutivas c, Materia b
																where c.Gcodigo = b.Gcodigo
																  and c.Ncodigo = b.Ncodigo
																  and b.Mconsecutivo = #form.Mconsecutivo# 
															)
															and a.Mactiva = 1
															and a.Mconsecutivo *= me.Mconsecutivo
															and a.MTcodigo = mt.MTcodigo"/>
					<cfinvokeargument name="align" value="left, right, right"/>
					<cfinvokeargument name="ajustar" value="N,N,N"/>
					<cfinvokeargument name="irA" value="MateriasElectivas.cfm"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="botones" value="Aplicar,Regresar"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formName" value="lista2"/>
					<cfinvokeargument name="checkedcol" value="checked"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
					<cfinvokeargument name="keys" value="KMateria"/>
					<cfinvokeargument name="formatos" value="S,N,N"/>
					<cfinvokeargument name="MaxRows" value="#form.MaxRows2#"/>
					<cfinvokeargument name="PageIndex" value="2"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="filtrar_por" value="a.Mnombre,a.Mhoras,a.Mcreditos"/>
					<cfinvokeargument name="showLink" value="false"/>
					
			</cfinvoke>
			<script language="javascript" type="text/javascript">
				
				<!---Regresa a la lista principal--->
				function funcRegresar(){
					location.href = "listaMateriasElectivas.cfm<cfoutput>?Mconsecutivo=#form.Mconsecutivo#&Pagina=#Form.Pagina#&Filtro_Mnombre=#Form.Filtro_Mnombre#&Filtro_Mhoras=#Form.Filtro_Mhoras#&Filtro_Mcreditos=#Form.Filtro_Mcreditos#&HFiltro_Mnombre=#Form.Filtro_Mnombre#&HFiltro_Mhoras=#Form.Filtro_Mhoras#&HFiltro_Mcreditos=#Form.Filtro_Mcreditos#</cfoutput>";
					return false;
				}
				
			</script>	
			<script language="JavaScript">
				if (document.lista2.chk != null) {
					if (document.lista2.chk.value != null) {// solo para uno
						if (document.lista2.chk.checked) document.lista2.chk.checked = true; else document.lista2.chk.checked = false;
							var a = document.lista2.chk.value.split("|");
							var Melectiva = a[0];
							document.lista2.Cual_Grupo.value += Melectiva ;
					} else {
						for (var counter = 0; counter < document.lista2.chk.length; counter++) {
							var a = document.lista2.chk[counter].value.split("|");
							var Melectiva = a[0];
							//alert(Melectiva);
							document.lista2.Cual_Grupo.value += Melectiva + ",";
						}
						if (document.lista2.Cual_Grupo.value != "") {
							document.lista2.Cual_Grupo.value = document.lista2.Cual_Grupo.value.substring(0,document.lista2.Cual_Grupo.value.length-1);
						}
					}
				}
			</script>
		</form>
	</td></tr>
</table>