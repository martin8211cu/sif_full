<cfsilent>
    <!--- TAG inputTime: ESTE TAG PERMITE CAPTURAR UNA HORA EN UN FORMATO 
    FIJO HH:mm = 24 horas (formato militar) --->
    <cfif ThisTag.ExecutionMode NEQ "START">
        <cfreturn>
    </cfif>
    <cfset def = QueryNew('Time')>
    <cfparam name="Attributes.form" default="form1"> <!--- Nombre del Formulario que contiene el objeto --->
    <cfparam name="Attributes.name" default="rfc"> <!--- Nombre del Objeto --->
    <cfparam name="Attributes.value" default="" type="string"> <!--- Valor del Objeto --->
    <cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del campo --->

</cfsilent>   
<cfoutput>
    
    <input type="text" id="#Attributes.name#" name="#Attributes.name#"
        value="#Attributes.value#"  size="#Attributes.size#" maxlength="13">
        <i id="#Attributes.name#_valido" class="fa fa-check text-success" style="display: none"></i>
        <i id="#Attributes.name#_invalido" class="fa fa-times text-danger" style="display: none"></i>
    <!--- <pre id="resultado"></pre> --->
    
    <script>

        $('###Attributes.name#').on('keyup keypress blur change', function(e) {
            #Attributes.name#_validarInput(this);
        });

        //Función para validar un RFC
        // Devuelve el RFC sin espacios ni guiones si es correcto
        // Devuelve false si es inválido
        // (debe estar en mayúsculas, guiones y espacios intermedios opcionales)
        function #Attributes.name#_rfcValido(rfc, aceptarGenerico = true) {
            const re       = /^([A-ZÑ&]{3,4}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$/;
            var   validado = rfc.match(re);
    
            if (!validado)  //Coincide con el formato general del regex?
                return false;
    
            //Separar el dígito verificador del resto del RFC
            const digitoVerificador = validado.pop(),
                rfcSinDigito      = validado.slice(1).join(''),
                len               = rfcSinDigito.length,
    
            //Obtener el digito esperado
                diccionario       = "0123456789ABCDEFGHIJKLMN&OPQRSTUVWXYZ Ñ",
                indice            = len + 1;
            var   suma,
                digitoEsperado;
    
            if (len == 12) suma = 0
            else suma = 481; //Ajuste para persona moral
    
            for(var i=0; i<len; i++)
                suma += diccionario.indexOf(rfcSinDigito.charAt(i)) * (indice - i);
            digitoEsperado = 11 - suma % 11;
            if (digitoEsperado == 11) digitoEsperado = 0;
            else if (digitoEsperado == 10) digitoEsperado = "A";
    
            //El dígito verificador coincide con el esperado?
            // o es un RFC Genérico (ventas a público general)?
            if ((digitoVerificador != digitoEsperado)
            && (!aceptarGenerico || rfcSinDigito + digitoVerificador != "XAXX010101000"))
                return false;
            else if (!aceptarGenerico && rfcSinDigito + digitoVerificador == "XEXX010101000")
                return false;
            return rfcSinDigito + digitoVerificador;
        }
    
    
        //Handler para el evento cuando cambia el input
        // -Lleva la RFC a mayúsculas para validarlo
        // -Elimina los espacios que pueda tener antes o después
        function #Attributes.name#_validarInput(input) {
            var rfc         = input.value.trim().toUpperCase(),
                resultado   = document.getElementById("resultado"),
                valido;
            
            var rfcCorrecto = #Attributes.name#_rfcValido(rfc);   // Acá se comprueba
        
            if (rfcCorrecto) {
                valido = "Válido";
                $("###Attributes.name#_invalido").hide();
                $("###Attributes.name#_valido").show();
                return true;
            } else {
                valido = "No válido"
                $("###Attributes.name#_valido").hide();
                $("###Attributes.name#_invalido").show();
                return false;
            }
            /* resultado.display    
            resultado.innerText = "RFC: " + rfc 
                                + "\nResultado: " + rfcCorrecto
                                + "\nFormato: " + valido; */
        }
    </script>
</cfoutput>    


