<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_conlis
    Campos="DVid, DVcodigo, DVdescripcion"
    Desplegables="N,S,S"
    Modificables="N,S,N"
    Size="0,20,20"
    tabindex="1"
    Title="Datos Variables"
	 
    Tabla=" DVdatosVariables a"
	 
    Columnas=" a.DVid,
               a.DVcodigo, 
               a.DVdescripcion"
    Filtro=" a.Ecodigo = #session.Ecodigo# and not exists (	select 1 
								from DVconfiguracionTipo
								where DVid = a.DVid and DVCidTablaCnf = #form.TEVid#)"
	 
	 Desplegar="DVcodigo, DVdescripcion"
    Etiquetas="Código, Descripción"
    filtrar_por="DVcodigo, DVdescripcion"
    Formatos="S,S"
    Align="left,left,left"
    form="form3"
    Asignar="DVid, DVcodigo, DVdescripcion"
    Asignarformatos="S,S,S"
    width="800"
    traerDatoOnBlur="true"
/>
