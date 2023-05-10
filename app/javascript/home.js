import ieStatementModule from "./ie_statement.js";
$( document ).ready(function() {
  (() => {
    'use strict'
  
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    const forms = document.querySelectorAll('.needs-validation')
  
    // Loop over them and prevent submission
    Array.from(forms).forEach(form => {
      form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
  
        form.classList.add('was-validated')
      }, false)
    })
  })()

  const addIEStatementModal = document.getElementById('addIeStatementModal')
  
  addIEStatementModal.addEventListener('shown.bs.modal', event => {
    $(document).on('submit', '#addIEStatementForm', function(event){
      event.preventDefault()

        document.getElementById('submitAddStatement').disabled = true;

        $.ajax({
          url: '/ie_statements',
          data: $(this).serialize(),
          method: 'POST'
        }).done(function(response){

          ieStatementModule.resetAddIEStatementForm()

          if(response.success){
            ieStatementModule.showMessage('notice', 'IE Statement created.')
            $('#homeContent').html(ieStatementModule.getStatementHtml(response))
          }else{
            ieStatementModule.showMessage('alert', response.message)
          }

        }).fail(function(jqXHR, textStatus, errorThrown){
          ieStatementModule.showMessage('alert', errorThrown)
          ieStatementModule.resetAddIEStatementForm()
        })
      
    })
  })

  $(document).on('click', '#addMoreIncome', function(){
    $('#incomeFieldsContainer').append($('#incomeField').html())
  })

  $(document).on('click', '#addMoreExpenditure', function(){
    $('#expenditureFieldsContainer').append($('#expenditureField').html())
  })

  $(document).on('click', '#addMoreDebtPayment', function(){
    $('#debtPaymentFieldsContainer').append($('#debtPaymentField').html())
  })

  $(document).on('click', '.field-close', function(){
    $(this).parent().parent().empty()
  })

  $(document).on('click', '#showStatements', function(){
    $.ajax({
      url: '/ie_statements',
      method: 'GET'
    }).done(function(response){
      if(response.success){
        let homeContent = ieStatementModule.getStatementListHtml(response.ie_statements)
        $('#homeContent').html(homeContent)
      }else{
        ieStatementModule.showMessage('alert', response.message)
      }
    }).fail(function(jqXHR, textStatus, errorThrown){
      ieStatementModule.showMessage('alert', errorThrown)
    })
  })

  $(document).on('click', '.show-statement', function(){
    $.ajax({
      url: '/ie_statements/'+$(this).attr('data-statement-id'),
      method: 'GET'
    }).done(function(response){
      console.log(response)
      if(response.success){
        let homeContent = ieStatementModule.getStatementHtml(response)
        $('#homeContent').html(homeContent)
      }else{
        ieStatementModule.showMessage('alert', response.message)
      }
    }).fail(function(jqXHR, textStatus, errorThrown){
      ieStatementModule.showMessage('alert', errorThrown)
    })
  })
});