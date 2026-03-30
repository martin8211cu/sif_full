
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Desde" Default="Fecha Desde" returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha_Hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_Hasta" />

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cantidad_de_Annos" Default="Cantidad de A&ntilde;os" returnvariable="LB_Cantidad_de_Annos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="C&eacute;dula" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Sexo" Default="Sexo" returnvariable="CMB_Sexo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Fecha_de_Ingreso" Default="A&ntilde;os de Antiguedad" returnvariable="CMB_Fecha_de_Ingreso"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Flashpaper" Default="Flashpaper" returnvariable="CMB_Flashpaper"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_PDF" Default="PDF" returnvariable="CMB_PDF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Excel" Default="Excel" returnvariable="CMB_Excel"/>
<cfoutput>

<body onLoad="Evaluar()">
<form action="antiguedadEmpleados-sql.cfm" method="get" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="margin:0">
	  
	   <tr id="fDesde">
		<td align="right"> <strong>#LB_Fecha_Desde#&nbsp;:&nbsp;</strong>&nbsp; </td>				
		<td><cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>					
	  </tr>
	  
	  <tr>	  	
		<td align="right" nowrap id="EtiqFechaCorte" >
		<input type="checkbox" name="ActivarRango" id="ActivarRango"  onChange="AtivarRangoFechas(this)"/>
		<strong>#LB_Fecha_de_Corte#&nbsp;:&nbsp;</strong>&nbsp;</td>							
		<td><cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
	  </tr>
			 	
	  <tr>
		<td  align="right" nowrap><strong>#LB_Cantidad_de_Annos#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<CF_inputNumber 
				name			= "AnnosMinimo"
				default			= "0"
				enteros			= "2"
				decimales		= "0"
				negativos		= "false">
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_Ceedula#</option>
				<option value="2">#CMB_Nombre#</option>
				<option value="3">#CMB_Sexo#</option>
				<option value="4" selected>#CMB_Fecha_de_Ingreso#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Formato#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="formato">
				<option value="flashpaper">#CMB_Flashpaper#</option>
				<option value="pdf">#CMB_PDF#</option>
				<option value="excel">#CMB_Excel#</option>
			</select>
		</td>
	  </tr>
	</table>
	<cf_botones values="Consultar,Limpiar">
</form>
</body>
</cfoutput>
<cf_qforms>
	<cf_qformsrequiredfield args="FechaHasta,#LB_Fecha_de_Corte#">
	<cf_qformsrequiredfield args="AnnosMinimo,#LB_Cantidad_de_Annos#">
	<cf_qformsrequiredfield args="OrderBy,#LB_Ordenar_por#">
	<cf_qformsrequiredfield args="formato,#LB_Formato#">
</cf_qforms>

<script>

function Evaluar(){
var objCheckBox = document.getElementById('ActivarRango');
AtivarRangoFechas(objCheckBox);
}

function AtivarRangoFechas(obj)
{

var objDesde =document.getElementById('fDesde');
	if (obj.checked){					
		objDesde.style.display='none';	
					
	} else {				
		objDesde.style.display='';		
	}		
}

</script>