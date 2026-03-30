﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"
	returnvariable="LB_NombreCompleto"/>
<!--- FIN VARIABLES DE TRADUCCION --->

	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="RHDRelacionCap a, DatosEmpleado  b"/>
		<cfinvokeargument name="columnas" value="b.DEid, 
												b.DEidentificacion, 
												{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as NombreCompleto, 
												 0 as BTNELIMINAR , 1 as BtnGenerarEmpl , 0 asBtnGenerarEmpls "/>
		<cfinvokeargument name="desplegar" value="DEidentificacion,NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_NombreCompleto#"/>
		<cfinvokeargument name="cortes" value=""/>
		<cfinvokeargument name="formatos" value="S,S"/>
		<cfinvokeargument name="filtro" value=" b.Ecodigo = #Session.Ecodigo#
												and RHRCid = #FORM.RHRCid#
												and a.DEid = b.DEid
												order by  b.DEapellido1, b.DEapellido2, b.DEnombre"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>	
		<cfinvokeargument name="irA" value="index.cfm"/>
		<cfinvokeargument name="MaxRows" value="50"/>
		<cfinvokeargument name="formName" value="form0"/>
		<cfinvokeargument name="incluyeForm" value="false"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="checkboxes" value=	"S"/>
		<cfinvokeargument name="keys" value="DEid"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="EmptyListMsg" value="***NO SE HAN AGREGADO EMPLEADOS A EVALUAR PARA ESTA RELACION***"/>
		<cfinvokeargument name="mostrar_filtro" value="true"/>
		<cfinvokeargument name="filtrar_automatico" value="true"/>
		<cfinvokeargument name="filtrar_por" value="b.DEidentificacion|{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})}"/>
		<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
	</cfinvoke>
