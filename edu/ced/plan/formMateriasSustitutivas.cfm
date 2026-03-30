
<!---
** Mantenimiento Materias Sustitutivas
** Hecho por: 		Rodolfo Jiménez Jara
** Fecha: 			10-Enero-2003
** Comentarios: 
** Aquí se relacionan las materias sustitutivas con los grados en que se podran recibir.
** una vez asociada esta con una materia electiva, no se puede borrar la relacion, primero ir al manntenimiento 
** de las electivas borrar la relación
--->

<!---
** Mantenimiento Materias Sustitutivas
** Modificado por: 	Karol Rodríguez
** Fecha: 			19-Enero-2006
** Comentarios: 	Hice los cambios en el uso del componente de listas y otros en los querys, basicamente la pantalla funciona igual 
** 					que como funcionaba antes, los cambios realizados son para adaptar la pantalla al framework de minisif
--->

<!------------------------Variables que vienen del url y de form---------------------------------------->

<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
<cfif isdefined("url.Mconsecutivo") and len(trim(url.Mconsecutivo))>
	<cfset form.Mconsecutivo = url.Mconsecutivo>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
<cfif isdefined("url.Filtro_Mnombre") and len(trim(url.Filtro_Mnombre))>
	<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
</cfif>
<cfif isdefined("url.Filtro_Mhoras") and len(trim(url.Filtro_Mhoras))>
	<cfset form.Filtro_Mhoras = url.Filtro_Mhoras>
</cfif>
<cfif isdefined("url.Filtro_Mcreditos") and len(trim(url.Filtro_Mcreditos))>
	<cfset form.Filtro_Mcreditos = url.Filtro_Mcreditos>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">					
<cfparam name="form.Filtro_Mnombre" default="">
<cfparam name="form.Filtro_Mhoras" default="0">
<cfparam name="form.Filtro_Mcreditos" default="0">
<cfif len(trim(form.Pagina)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina = 1>
</cfif>
<!--- PARAMETROS DEL DETALLE Y LA LISTA DE DETALLES --->
<!---  VARIABLE LlAVE PARA CUANDO VIENE DEL SQL --->
<cfif isdefined("url.Gcodigo") and len(trim(url.Gcodigo))>
	<cfset form.Gcodigo = url.Gcodigo>
</cfif>
<cfif isdefined("url.Ncodigo") and len(trim(url.Ncodigo))>
	<cfset form.Ncodigo = url.Ncodigo>
</cfif>
<cfif isdefined("url.KMateria") and len(trim(url.KMateria))>
	<cfset form.KMateria = url.KMateria>
</cfif>

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina2 = url.Pagina2>
</cfif>					
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
	<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
	<cfset form.Gcodigo = 0>
	<cfset form.Ncodigo = 0>
	<cfset form.KMateria = 0>
</cfif>					
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
	<cfset form.Pagina2 = form.PageNum2>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
<cfif isdefined("url.Filtro_Gdescripcion") and len(trim(url.Filtro_Gdescripcion))>
	<cfset form.Filtro_Gdescripcion = url.Filtro_Gdescripcion>
</cfif>
<cfif isdefined("url.Filtro_Gorden") and len(trim(url.Filtro_Gorden))>
	<cfset form.Filtro_Gorden = url.Filtro_Gorden>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina2" default="1">					
<cfparam name="form.Filtro_Gdescripcion" default="">
<cfparam name="form.Filtro_Gorden" default="0">
<cfparam name="form.MaxRows2" default="10">
<cfif len(trim(form.Pagina2)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina2 = 1>
</cfif>	

<!------------------------------SQL DEL MANTENIMIENTO-------------------------------------------->

<!---Aplica los tipos de materia--->
<cfif isdefined("Form.btnAplicar")>
	
	<cfset mens = "">											<!--- variable para el mensaje de error --->
	
	<cfif isdefined("Form.chk_ant") and len(trim(Form.chk_ant))neq 0>	
		
		<cfset a=ListToArray(Form.chk_ant,',')>					<!--- lista los valores de chk_ant para borrar de la tabla GradoSustitutivas las que no tengan una relacion con la tabla MateriaElectiva --->
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			<cfset Gcodigo_a = b[1]>
			<cfset Ncodigo_a = b[2]>
			<cfset Mconsecutivo2_a = b[3]>
			
			<cfquery name="rsDelete" datasource="#Session.Edu.DSN#"><!--- Borra todas las relaciones existes si no existen en la tabla MateriaElectiva --->
				delete GradoSustitutivas
				from GradoSustitutivas x
				where Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gcodigo_a#">
				  and Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo_a#">
				  and Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#"> 
				 <!--- Comentado por que no funciona bien ---> 
				  <!--- and not exists ( select 1							<!--- evita que exista una relación en  MateriaElectiva --->
									from MateriaElectiva a, Materia b
									where a.Melectiva = b.Mconsecutivo
										  and b.Gcodigo = x.Gcodigo)  --->
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfif isdefined("Form.chk")>								<!--- Existen cheks nuevos activos? --->
		<cfset a=ListToArray(Form.Chk,',')>						<!--- Lista los registros que fueron activados y realiza un ciclo con cada registro --->
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			<cfset Gcodigo = b[1]>
			<cfset Ncodigo = b[2]>
			<cfset Mconsecutivo2 = b[3]>
																<!--- Pregunta si ya existe una relación en la tabla GradoSustitutivas con el mismo grado,nivel y materia que desea agregar --->
			<cfquery name="rsExiste" datasource="#Session.Edu.DSN#">	
				select count(1) as existe
				from GradoSustitutivas
				where Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gcodigo#">
				  and Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo#"> 
				  and Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mconsecutivo2#">

			</cfquery>			
			
			<cfif rsExiste.existe eq 0>							<!--- Significa que no existe la relacion actualmente en la tabla entonces la agrega --->
				
				<cfquery name="rsAplicaGrado" datasource="#Session.Edu.DSN#">
					insert GradoSustitutivas (Gcodigo, Ncodigo, Mconsecutivo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Gcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mconsecutivo2#">
							)
				</cfquery>
				
			<cfelse>											<!--- Trae la descripcion del grado, nivel y materia, para concatenar un mensaje de error. --->
				
				<cfquery name="rsAplicaGrado" datasource="#Session.Edu.DSN#">
					select  rtrim(ltrim(a.Gdescripcion)) as Gdescripcion, rtrim(ltrim(b.Ndescripcion))as Ndescripcion, rtrim(ltrim(c.Mnombre)) as Mnombre
					from GradoSustitutivas x , Grado a, Nivel b, Materia c
					where x.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gcodigo#">
					  and x.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo#">
					  and x.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mconsecutivo2#">
					  and a.Gcodigo = x.Gcodigo 
					  and b.Ncodigo = x.Ncodigo 
					  and c.Mconsecutivo = x.Mconsecutivo 
				</cfquery>
				
				<cfif mens neq "">								<!--- Concatena el mensaje de error --->
					<cfset mens = mens &',  '& rsAplicaGrado.Gdescripcion &'-'& rsAplicaGrado.Ndescripcion&'-'& rsAplicaGrado.Mnombre>	
				<cfelse>
					<cfset mens = mens &'  '& rsAplicaGrado.Gdescripcion &'-'& rsAplicaGrado.Ndescripcion&'-'& rsAplicaGrado.Mnombre>
				</cfif>
				
			</cfif>
			
		</cfloop>												<!--- Fin del ciclo --->
		
	</cfif>														<!--- Fin  Existen cheks activos? --->
	
	<cfif mens neq "">											<!---  Existe mensaje de error?--->
		
		<cfset pg="">											<!--- si la pagina de la lista esta definida la pone en la variable para ser enviada por URL --->
		<cfif isdefined("Pagina")>
			<cfset pg="Pagina="&#Form.Pagina#&"&"> 
		</cfif>
		
		<cfset paramss="">										<!--- si esta definida la llave, la pone en la variable para ser enviada por URL --->			
		<cfif isdefined("Form.Mconsecutivo") and len(trim(Form.Mconsecutivo))>
		   <cfset paramss="&Mconsecutivo="&form.Mconsecutivo>
		</cfif>
		
																<!--- Pone las varibles en la URL --->
		<cfset Request.Error.Url = "MateriasSustitutivas.cfm?#pg#Filtro_Gdescripcion=#Form.Filtro_Gdescripcion#&Filtro_Gorden=#Form.Filtro_Gorden#&HFiltro_Gdescripcion=#Form.Filtro_Gdescripcion#&HFiltro_Gorden=#Form.Filtro_Gorden##paramss#">
											
																<!--- Muestra el mensaje de error --->
		<cfthrow message="Error: EL o los siguiente(s) grado(s) se mantendrán aplicados por que están relacionados a una Materia Electiva:#mens#">	
	</cfif>
	
</cfif>
<!---------------------------------------------------FIN DEL SQL DEL MANTENIMIENTO---------------------------------------------------------------------------------------------------------------------------->



<!--- CONSULTAS--->																
<cfquery datasource="#Session.Edu.DSN#" name="rsMateria"><!--- Toma los valores que seran mostrados en pantalla --->	
	select substring(c.Mnombre,1,50) as Mnombre, substring(a.Ndescripcion,1,50) as Ndescripcion, isnull(b.Gdescripcion,'No Aplica') as Gdescripcion,
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
	  and a.Ncodigo = c.Ncodigo 
	  and b.Ncodigo =* c.Ncodigo 
	  and b.Gcodigo =* c.Gcodigo 
	  and c.MTcodigo = d.MTcodigo
</cfquery>
		
															
<form name="filtros" action="MateriasSustitutivas.cfm" method="post" style="margin:0">	<!--- Encabezado de la página, infomacion general --->
	<table width="100%" class="tituloAlterno" cellpadding="0"  cellspacing="0" style="margin:0">
		<!---<thead>--->
			<tr> 
				<td colspan="5" align="center" ><strong>Datos de Materia</strong></td>
			</tr>
		<!---</thead>--->
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
		
	<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
	<input name="Cual_Nivel" type="hidden" id="Cual_Nivel" value="">
	<input name="Cual_Materia" type="hidden" id="Cual_Materia" value="">
	<input name="chk_ant" type="hidden" id="chk_ant" value="">
		
</form>

																<!--- Lista de Grados por nivel por materia (resibe el id de la materia) --->	
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin:0">
<tr> 
	<td>
	<form name="lista" method="post" action="MateriasSustitutivas.cfm" style="margin:0">
		
		<input type="hidden" name="Mconsecutivo" value="<cfif isdefined("Form.Mconsecutivo")><cfoutput>#Form.Mconsecutivo#</cfoutput></cfif>"> 
		<input name="Mnombre" type="hidden" id="Mnombre" value="<cfif isdefined("Form.Mnombre")><cfoutput>#Form.Mnombre#</cfoutput></cfif>">
		<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
		<input name="Cual_Nivel" type="hidden" id="Cual_Nivel" value="">
		<input name="Cual_Materia" type="hidden" id="Cual_Materia" value="">
		<input name="chk_ant" type="hidden" id="chk_ant" value="">
		<input name="pagina" type="hidden" id="pagina" value="<cfoutput>#Form.pagina#</cfoutput>">
		<input name="Filtro_Mnombre" type="hidden" id="Filtro_Mnombre" value="<cfoutput>#Form.Filtro_Mnombre#</cfoutput>">
		<input name="Filtro_Mhoras" type="hidden" id="Filtro_Mhoras" value="<cfoutput>#Form.Filtro_Mhoras#</cfoutput>">
		<input name="Filtro_Mcreditos" type="hidden" id="Filtro_Mcreditos" value="<cfoutput>#Form.Filtro_Mcreditos#</cfoutput>">
		
		<cfinvoke 
		 component="edu.Componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="tabla" value="Materia m, MateriaTipo mt, Grado a, Nivel b, GradoSustitutivas c"/>
			<cfinvokeargument name="columnas" value="a.Ncodigo, a.Gcodigo, #Form.Mconsecutivo# as KMateria, substring(b.Ndescripcion,1,50) as Ndescripcion, substring(a.Gdescripcion,1,50) as Gdescripcion, a.Gorden, +convert(varchar,c.Gcodigo)+'|'+convert(varchar, c.Ncodigo)+'|'+convert(varchar, c.Mconsecutivo) as checked"/>
			<cfinvokeargument name="desplegar" value="Gdescripcion, Gorden"/>
			<cfinvokeargument name="etiquetas" value="Descripción, Orden"/>
			<cfinvokeargument name="formatos" value="V,I"/>
			<cfinvokeargument name="filtro" value="m.Mconsecutivo = #Form.Mconsecutivo#
													and mt.CEcodigo = #Session.Edu.CEcodigo#
													and c.Mconsecutivo = #Form.Mconsecutivo#
													and m.MTcodigo = mt.MTcodigo
													and b.CEcodigo = mt.CEcodigo
													and a.Ncodigo = b.Ncodigo
													and a.Ncodigo = m.Ncodigo 
													and a.Gcodigo *= c.Gcodigo
													order by b.Norden, a.Gorden"/>
			<cfinvokeargument name="align" value="left, right"/>
			<cfinvokeargument name="ajustar" value="N,N"/>
			<cfinvokeargument name="irA" value="MateriasSustitutivas.cfm"/>
			<cfinvokeargument name="cortes" value="Ndescripcion"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="keys" value="Gcodigo, Ncodigo,KMateria"/>
			<cfinvokeargument name="checkedcol" value="checked"/>
			<cfinvokeargument name="botones" value="Aplicar, Regresar"/>
			<cfinvokeargument name="mostrar_filtro" value="true"/>
			<cfinvokeargument name="filtrar_automatico" value="true"/>
			<cfinvokeargument name="filtrar_por" value="a.Gdescripcion,a.Gorden"/>
			<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
			<cfinvokeargument name="MaxRows" value="#form.MaxRows2#"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="PageIndex" value="2"/>
			<cfinvokeargument name="incluyeForm" value="false"/>
			<cfinvokeargument name="formname" value="lista"/>
			<cfinvokeargument name="navegacion" value="&Mconsecutivo=#form.Mconsecutivo#&Pagina=#Form.Pagina#&Filtro_Mnombre=#Form.Filtro_Mnombre#&Filtro_Mhoras=#Form.Filtro_Mhoras#,&Filtro_Mcreditos=#Form.Filtro_Mcreditos#"/>
		</cfinvoke>
		 <script language="javascript" type="text/javascript">
			
			<!---Regresa a la lista principal--->
			function funcRegresar(){
				location.href = "listaMateriasSustitutivas.cfm<cfoutput>?Mconsecutivo=#form.Mconsecutivo#&Pagina=#Form.Pagina#&Filtro_Mnombre=#Form.Filtro_Mnombre#&Filtro_Mhoras=#Form.Filtro_Mhoras#&Filtro_Mcreditos=#Form.Filtro_Mcreditos#&HFiltro_Mnombre=#Form.Filtro_Mnombre#&HFiltro_Mhoras=#Form.Filtro_Mhoras#&HFiltro_Mcreditos=#Form.Filtro_Mcreditos#</cfoutput>";
				return false;
			}
		</script>
		
		<script language="JavaScript">
			
			if (document.lista.chk != null) {
				var chk_ant = "";
				if (document.lista.chk.value != null) {
					if (document.lista.chk.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
						var a = document.lista.chk.value.split("|");
						
						if(chk_ant == "")
							chk_ant += a[0]+'|'+a[1]+'|'+a[2]; 
						else
							chk_ant += ','+a[0]+'|'+a[1]+'|'+a[2];
					
				} else {
					for (var counter = 0; counter < document.lista.chk.length; counter++) {
						var a = document.lista.chk[counter].value.split("|");
						
						if(chk_ant == "")
							chk_ant += a[0]+'|'+a[1]+'|'+a[2]; 
						else
							chk_ant += ','+a[0]+'|'+a[1]+'|'+a[2];
						
					}
				}
				document.lista.chk_ant.value = chk_ant;
			}
		
			<!---  --->	
			if (document.lista.chk != null) {
				var chk_ant = "";
				if (document.lista.chk.value != null) {
					if (document.lista.chk.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
						var a = document.lista.chk.value.split("|");
						var Melectiva = a[0];
						var Nivel = a[1];
						var Materia = a[2];
						
						document.lista.Cual_Grupo.value += Melectiva ;
						document.lista.Cual_Nivel.value += Nivel ;
						document.lista.Cual_Materia.value += Materia ;
					
				} else {
					for (var counter = 0; counter < document.lista.chk.length; counter++) {
						var a = document.lista.chk[counter].value.split("|");
						var Melectiva = a[0];
						var Nivel = a[1];
						var Materia = a[2];
						
						document.lista.Cual_Grupo.value += Melectiva + ",";
						document.lista.Cual_Nivel.value += Nivel + ",";
						document.lista.Cual_Materia.value += Materia + ",";
					
					}
					if (document.lista.Cual_Grupo.value != "") {
						document.lista.Cual_Grupo.value = document.lista.Cual_Grupo.value.substring(0,document.lista.Cual_Grupo.value.length-1);
					}
					if (document.lista.Cual_Nivel.value != "") {
						document.lista.Cual_Nivel.value = document.lista.Cual_Nivel.value.substring(0,document.lista.Cual_Nivel.value.length-1);
					}
					if (document.lista.Cual_Materia.value != "") {
						document.lista.Cual_Materia.value = document.lista.Cual_Materia.value.substring(0,document.lista.Cual_Materia.value.length-1);
					}
				}
				
			}
				
		</script>
	</form>
	</td>
</tr>
</table>


