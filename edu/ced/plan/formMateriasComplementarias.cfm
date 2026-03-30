<cfquery datasource="#Session.Edu.DSN#" name="rsMateria">
	select substring(c.Mnombre,1,50) as Mnombre, 
			substring(a.Ndescripcion,1,50) as Ndescripcion, 
			substring(b.Gdescripcion,1,50) as Gdescripcion, 
			convert(varchar,c.Mconsecutivo) as Mconsecutivo,
	       case c.Melectiva
		        when 'R' then 'Regular'
				when 'S' then 'Sustitutiva'
				when 'E' then 'Electiva'
				when 'C' then 'Complementaria'
				else ''
			end as Modalidad,
			d.MTdescripcion
	from Nivel a, Grado b, Materia c, MateriaTipo d
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and c.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	  and a.Ncodigo = b.Ncodigo 
	  and b.Ncodigo = c.Ncodigo 
	  and b.Gcodigo = c.Gcodigo 
	  and c.MTcodigo = d.MTcodigo
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td class="tituloAlterno" colspan="3">Datos de Materia</td>
	</tr>
	<tr> 
		<td class="tituloAlterno" rowspan="2" width="35%" align="center" valign="middle" style="font-size: 13pt; font-weight: bold;" nowrap><cfoutput>#rsMateria.Mnombre# <!--- #rsMateria.Mconsecutivo# ---></cfoutput></td>
		<td class="tituloAlterno" nowrap><strong>Nivel:</strong> <cfoutput>#rsMateria.Ndescripcion#</cfoutput> </td>
		<td class="tituloAlterno" nowrap><strong>Tipo de Materia:</strong> <cfoutput>#rsMateria.MTdescripcion#</cfoutput></td>
	</tr>
	<tr> 
		<td class="tituloAlterno" nowrap> <strong>Grado:</strong> <cfoutput>#rsMateria.Gdescripcion#</cfoutput> </td>
		<td class="tituloAlterno" nowrap><strong>Modalidad:</strong> <cfoutput>#rsMateria.Modalidad#</cfoutput></td>
	</tr>
</table>

<cfif isdefined("Form.btnAplicar")>
	<cftransaction>
		<cfquery name="ABC_MateriaElectiva" datasource="#Session.Edu.DSN#">
			delete MateriaElectiva 
			where Mconsecutivo in  (#form.CUAL_GRUPO#)  
			  and Melectiva in (#form.Mconsecutivo#)
		</cfquery>
		<cfif isdefined("Form.Chk")>
			<cfset a=ListToArray(Form.Chk,',')>
			<cfloop index="i" from="1" to="#ArrayLen(a)#">
				<cfset b = ListToArray(a[i],'|')>
				 <cfset Melectiva = b[1]>
				<cfquery name="ABC_MateriaElectiva" datasource="#Session.Edu.DSN#">
						insert MateriaElectiva ( Mconsecutivo, Melectiva)
						values (#Melectiva#, #form.Mconsecutivo#
									)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cfif>

<cfinvoke 
	 component="edu.Componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="Materia a, Nivel b, Materia c, MateriaElectiva d"/>
		<cfinvokeargument name="columnas" value="a.Mconsecutivo, substring(a.Mnombre,1,50) as Mnombre, 
																		a.Mhoras, a.Mcreditos, d.Mconsecutivo as checked, 
																		'' as CUAL_GRUPO, '' as e"/>
		<cfinvokeargument name="desplegar" value="Mnombre, Mhoras, Mcreditos, e"/>
		<cfinvokeargument name="filtrar_por" value="a.Mnombre, a.Mhoras, a.Mcreditos,''"/>
		<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Horas, Cr&eacute;ditos, "/>
		<cfinvokeargument name="formatos" value="S,I,I,U"/>
		<cfinvokeargument name="Filtro" value="b.CEcodigo = #Session.Edu.CEcodigo# 
											   and a.Melectiva = 'R' 
											   and a.Mactiva = 1
											   and c.Mconsecutivo = #form.Mconsecutivo# 
											   and a.Ncodigo = b.Ncodigo 
											   and a.Ncodigo = c.Ncodigo 
											   and a.Gcodigo = c.Gcodigo 
											   and a.Mconsecutivo *= d.Mconsecutivo  
											   order by a.Mnombre"/>
		<cfinvokeargument name="align" value="left, right, right, right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="MateriasComplementarias.cfm"/>
		<cfinvokeargument name="checkboxes" value="S"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="botones" value="Aplicar,Lista"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="keys" value="Mconsecutivo"/>
		<cfinvokeargument name="checkedcol" value="checked"/>
		<cfinvokeargument name="conexion" 	value="#Session.Edu.Dsn#"/>
		<cfinvokeargument name="mostrar_Filtro" value="true"/>
		<cfinvokeargument name="filtrar_automatico" value="true"/>
		<cfinvokeargument name="maxrows" value="15"/>
		<cfinvokeargument name="formname" value="lista2"/>
		<cfinvokeargument name="PageIndex" value="2"/>		
</cfinvoke>

<cfset params = "?Mconsecutivo=#Form.Mconsecutivo#&Pagina=#Form.Pagina#&Filtro_Materia=#Form.Filtro_Materia#&Filtro_horas=#Form.Filtro_horas#&Filtro_Creditos=#Form.Filtro_Creditos#&hFiltro_Materia=#Form.hFiltro_Materia#&hFiltro_Horas=#Form.hFiltro_Horas#&hFiltro_Creditos=#Form.hFiltro_Creditos#">

<script language="JavaScript">
	<!--
	//Si hay al menos un elemento en la lista
 	if (document.lista2.chk != null) {
		//Si hay solo un elemento en la lista
		if (document.lista2.chk.value != null) {
			if (document.lista2.chk.checked) 
				document.lista2.chk.checked = true; 
			else 
				document.lista2.chk.checked = false;
			//crea el arreglo 'a' con los valores de la lista separada por '|', 'chk'.
			var a = document.lista2.chk.value.split("|");
			//Guarda el primer elemento de la lista que corresponde al Mconsecutivo en Melectiva
			var Melectiva = a[0];
			//Agrega el valor de Melectiva a CUAL_GRUPO
			document.lista2.CUAL_GRUPO.value += Melectiva ;
		}
		//Si hay mas de un elemento en la lista
		else {
			//recorre los checkboxes de la lista
			for (var counter = 0; counter < document.lista2.chk.length; counter++) {
				if (document.lista2.chk[counter].checked) 
					document.lista2.chk[counter].checked = true; 
				else 
					document.lista2.chk[counter].checked = false;
				//Crea el arreglo 'a' con el valor del checkbox que estamos viendo en esta iteración
				var a = document.lista2.chk[counter].value.split("|");
				//Guarda el primer elemento de la lista que corresponde al Mconsecutivo en Melectiva
				var Melectiva = a[0];
				//Agrega el valor de Melectiva a CUAL_GRUPO, como una lista separada por comas
				document.lista2.CUAL_GRUPO.value += Melectiva + ",";
			}
			//Si cual_grupo tiene al menos un valor
			if (document.lista2.CUAL_GRUPO.value != "") {
				//borra la última coma de cual_grupo
				document.lista2.CUAL_GRUPO.value = document.lista2.CUAL_GRUPO.value.substring(0,document.lista2.CUAL_GRUPO.value.length-1);
			}
		}
	}
	function funcFiltrar2(){
		document.lista2.action = "MateriasComplementarias.cfm<cfoutput>#params#</cfoutput>";
		return true;
	}
	function funcAplicar(){
		document.lista2.action = "MateriasComplementarias.cfm<cfoutput>#params#</cfoutput>";
		return true;f
	}
	function funcLista(){
		document.lista2.action = "listaMateriasComplementarias.cfm<cfoutput>#params#</cfoutput>";
		return true;
	}
	-->
</script>

