///////////////////////////////////////////////////////////////////////////////
//  Copyright Christopher Kormanyos 2007 - 2015.
//  Distributed under the Boost Software License,
//  Version 1.0. (See accompanying file LICENSE_1_0.txt
//  or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#include <mcal_gpt.h>
#include <mcal_reg.h>

namespace
{
  // The one (and only one) system tick.
  mcal::gpt::value_type system_tick;
}

extern "C"
void __vector_16() __attribute__((signal, used, externally_visible));

void __vector_16()
{
  // Increment the 32-bit system tick with 0x80, representing 128 microseconds.
  system_tick += static_cast<std::uint8_t>(0x80U);
}

void mcal::gpt::init(const config_type*)
{
  // Clear the timer0 overflow flag.
  mcal::reg::reg_access_static<std::uint8_t, std::uint8_t, mcal::reg::tifr0, 0x01U>::reg_set();

  // Enable the timer0 overflow interrupt.
  mcal::reg::reg_access_static<std::uint8_t, std::uint8_t, mcal::reg::timsk0, 0x01U>::reg_set();

  // Set the timer0 clock source to f_osc/8 = 2MHz and begin counting.
  mcal::reg::reg_access_static<std::uint8_t, std::uint8_t, mcal::reg::tccr0b, 0x02U>::reg_set();
}

mcal::gpt::value_type mcal::gpt::secure::get_time_elapsed()
{
  // Return the system tick using a multiple read to ensure data consistency.

  typedef std::uint8_t timer_address_type;
  typedef std::uint8_t timer_register_type;

  // Do the first read of the timer0 counter and the system tick.
  const timer_register_type   tim0_cnt_1 = mcal::reg::reg_access_static<timer_address_type,
                                                                        timer_register_type,
                                                                        mcal::reg::tcnt0>::reg_get() / 2U;

  const mcal::gpt::value_type sys_tick_1 = system_tick;

  // Do the second read of the timer0 counter.
  const timer_register_type   tim0_cnt_2 = mcal::reg::reg_access_static<timer_address_type,
                                                                        timer_register_type,
                                                                        mcal::reg::tcnt0>::reg_get() / 2U;

  // Perform the consistency check.
  const mcal::gpt::value_type consistent_microsecond_tick
    = ((tim0_cnt_2 >= tim0_cnt_1) ? mcal::gpt::value_type(sys_tick_1  | tim0_cnt_1)
                                  : mcal::gpt::value_type(system_tick | tim0_cnt_2));

  return consistent_microsecond_tick;
}
