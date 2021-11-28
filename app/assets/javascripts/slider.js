$(document).on('turbolinks:load', () => {
  $(".image-slider").slick({
    autoplay: true,
    autoplaySpeed: 3000,
    pauseOnHover: true,
    arrows: false,
  })
  $(".vehicle-slider").slick({
    autoplay: true,
    autoplaySpeed: 3000,
    pauseOnHover: true,
    arrows: false,
  })
});