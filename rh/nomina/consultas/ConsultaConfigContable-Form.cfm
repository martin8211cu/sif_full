<style type="text/css">
	.tit{
		font-weight:bold;
	}
	
	.visible{
		display:none;
	}
	.novisible{
		display:block;
	}
</style>

<!---- traduccion ----->	
<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_Acciones"
Default="Acciones"
returnvariable="LB_Acciones"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_ConceptosDePago"
Default="Conceptos de Pago"
returnvariable="LB_ConceptosDePago"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_Deducciones"
Default="Deducciones"
returnvariable="LB_Deducciones"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_SociosDeNegocio"
Default="Socios de Negocio"
returnvariable="LB_SociosDeNegocio"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CargasObreroPatronales"
Default="Cargas Obrero Patronales"
returnvariable="LB_CargasObreroPatronales"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CentrosFuncionales"
Default="Centros Funcionales"
returnvariable="LB_CentrosFuncionales"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CatalogoContable"
Default="Cat&aacute;logo Contable"
returnvariable="LB_CatalogoContable"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CombinacionDeCuentas"
Default="Combinaci&oacute;n de Cuentas"
returnvariable="LB_CombinacionDeCuentas"/>	


<form name="form1" method="post" action="ConsultaConfigContable-Result.cfm" >

<table border="0" cellpadding="5" cellspacing="0">

	<tr id="trtregistro">
		<td class="tit" align="right"><cf_translate key="LB_TipoConfiguracion"> Tipo Configuraci&oacute;n:&nbsp;</cf_translate></td>
		<td>
			<select name="cmbOpcion">
				<cfoutput>
				<option value="1">#LB_Acciones#</option>
        		<option value="2">#LB_ConceptosDePago#</option>
				<option value="3">#LB_Deducciones#</option>
				<option value="4">#LB_SociosDeNegocio#</option>
				<option value="5">#LB_CargasObreroPatronales#</option>
				<option value="6">#LB_CentrosFuncionales#</option>	
				<option value="7">#LB_CatalogoContable#</option>
				<option value="8">#LB_CombinacionDeCuentas#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
			<input type="submit" id="consultar" name="consultar" value="Consultar" class="btnAplicar"/>
			<input type="hidden"   name="clase" id="clase" value="ListaNon">
		</td>
	</tr>
</table>
</form>