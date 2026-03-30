<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Aplicar Incidencia" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="T&iacute;tulo" returnvariable="LB_Titulo"/>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="2">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</td>
	</tr>
	<tr>
		<td width="50%" valign="top">
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="CRCAjusteCuenta i
						inner join CRCCuentas c
							on c.id = i.CRCCuentasid
						inner join SNegocios sn
							on sn.SNid = c.SNegociosSNid"
				columnas="
						sn.SNid
						, c.id as ID_cta
						, i.id as ID_AJ
						, sn.SNidentificacion
						, sn.SNnombre
						, c.Numero
						, c.Tipo
						, i.Observaciones
						, i.Monto"
				desplegar="SNidentificacion,SNnombre,Numero,Tipo,Observaciones,Monto"
				etiquetas="Identificacion,Nombre,Numero Cuenta,Tipo Cuenta,Observaciones,Monto"
				formatos="S,S,S,S,S,M"
				filtro="i.Ecodigo=#session.Ecodigo# AND isnull(i.Aplicada,0) = 0"
				align="left,left,left,left,left,left"
				checkboxes="S"
				filtrar_automatico="true"
				showLink ="true"
				checkall="S"
				checkbox_function ="funcChk(this)"
				botones="Nuevo,Aplicar"
				formName="form1"
				ira="AplicarAjuste_sql.cfm"
				keys="ID_AJ">
			</cfinvoke>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>

<script>
    /* document.form1.btnEliminar.value='Rechazar' */
    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }

	function ValidarSeleccion(){
        var checked = false;
        var seleccionados = $("input[name^='chk']:checked:enabled",'#form1').length;
		
        if(seleccionados == 0){
            alert("No ha seleccionado al menos 1 ajuste");
            return false;
        }
        return true;
	}

	function funcAplicar(){
		if(ValidarSeleccion()){
			return confirm("Esta seguro que quiere APLICAR estos ajustes?");
		}
		return false;
	}

	function funcEliminar(){
		if(ValidarSeleccion()){
			return confirm("Esta seguro que quiere RECHAZAR estos ajustes?");
		}
		return false;
	}

</script>